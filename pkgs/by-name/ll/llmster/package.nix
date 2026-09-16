{
  lib,
  stdenv,
  fetchurl,
  addDriverRunpath,
  patchelf,
  makeBinaryWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeScript,
  libxcrypt-legacy,
  appVariant ? "full",
  manifestFile ? ./manifest.json,
}:
let
  manifest = lib.importJSON manifestFile;
  versionParts = lib.splitString "-" manifest.version;
  version = lib.head versionParts;
  build = lib.last versionParts;
  platforms = {
    aarch64-darwin = "darwin-arm64";
    aarch64-linux = "linux-arm64";
    x86_64-linux = "linux-x64";
  };
  platform = platforms.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "llmster";
  version = "${version}+${build}";

  src = fetchurl {
    url = "https://llmster.lmstudio.ai/download/${version}-${build}-${platform}.${appVariant}.tar.gz";
    sha512 = manifest.checksums.${platform};
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc
    libxcrypt-legacy
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    addDriverRunpath
    patchelf
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    mv llmster .bundle $out/libexec/
    makeWrapper $out/libexec/llmster $out/bin/llmster

    runHook postInstall
  '';

  # Bun-compiled executables (llmster, node, lms) embed runtime data after the ELF sections.
  # patchelf --add-rpath and autoPatchelfHook's --set-rpath rearrange ELF sections to grow
  # .dynamic/.dynstr, which shifts the appended data and causes SIGSEGV at runtime.
  #
  # For executables: only patch the interpreter (minimal, less likely to corrupt) and provide
  # library paths via LD_LIBRARY_PATH through a binary wrapper instead of modifying the rpath.
  # For shared libraries (.so/.node): these are standard ELF without appended data, so patching
  # the rpath with --add-rpath is safe.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    local interpreter="$(cat $NIX_CC/nix-support/dynamic-linker)"
    local rpath="${lib.makeLibraryPath (finalAttrs.buildInputs ++ [ addDriverRunpath.driverLink ])}"
    find $out/libexec -type f \( -executable -o -name '*.so' -o -name '*.so.*' -o -name '*.node' \) | while read -r file; do
      if patchelf --print-interpreter "$file" &>/dev/null; then
        patchelf --set-interpreter "$interpreter" "$file"
        wrapProgram "$file" \
          --prefix LD_LIBRARY_PATH : "$rpath"
      elif patchelf --print-rpath "$file" &>/dev/null; then
        patchelf --add-rpath "$rpath" "$file"
      fi
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  strictDeps = true;

  passthru.updateScript = writeScript "update-llmster" ''
    #!/usr/bin/env nix-shell
    #!nix-shell --pure -i bash -p curl jq cacert gawk

    set -euo pipefail

    version="$(curl -fsSL "https://lmstudio.ai/install.sh" | awk -F'"' '/^APP_VERSION=/ {print $2; exit}')"
    manifest="$(jq -n --arg v "$version" '{version: $v, checksums: {}}')"

    for platform in ${toString (lib.attrValues platforms)}; do
      checksum="$(curl -fsSL "https://llmster.lmstudio.ai/download/$version-$platform.${appVariant}.sha512" 2>/dev/null)" || continue
      manifest="$(echo "$manifest" | jq --arg p "$platform" --arg c "$checksum" '.checksums[$p] = $c')"
    done

    echo "$manifest" > "${toString manifestFile}"
  '';

  meta = {
    description = "CLI tool for LM Studio - discover, download, and run local LLMs";
    homepage = "https://lmstudio.ai";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "llmster";
    platforms = lib.attrNames platforms;
  };
})
