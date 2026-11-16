{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  llvmPackages,
  runtimeShell,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "1.0.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/clice-io/clice/releases/download/v${version}/clice-${version}.x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-ndGBqsnIHK52slXpU9ohyeYD/FtAZEfrJsler2ftlpo=";
    };
    aarch64-linux = {
      url = "https://github.com/clice-io/clice/releases/download/v${version}/clice-${version}.aarch64-unknown-linux-gnu.tar.gz";
      hash = "sha256-t+ts5lr7nNxSKdrfGxpWFIXc2ykqBtaIV81gl3FvCLo=";
    };
    aarch64-darwin = {
      url = "https://github.com/clice-io/clice/releases/download/v${version}/clice-${version}.aarch64-apple-darwin.tar.gz";
      hash = "sha256-lBrNbsTHRkRKVABkUiCc0O+Y9aNO7lCJUgAWxApB+Cw=";
    };
  };

  srcInfo =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "clice";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl srcInfo;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin lib $out/

    runHook postInstall
  '';

  postFixup = ''
    mv $out/bin/clice $out/bin/.clice-wrapped
    substitute ${./wrapper} $out/bin/clice \
      --replace-fail '@clang@' '${llvmPackages.clang}' \
      --replace-fail '@shell@' '${runtimeShell}' \
      --replace-fail '@out@' "$out"
    chmod --reference=$out/bin/.clice-wrapped $out/bin/clice
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/clice";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C/C++ language server built on LLVM/Clang";
    longDescription = ''
      clice is a C/C++ language server designed to go beyond clangd and ccls.
      It features multi-process compilation, C++20 named module support,
      compilation contexts, and built-in command-line tools for indexing,
      linting, formatting, querying, and refactoring.
    '';
    homepage = "https://github.com/clice-io/clice";
    changelog = "https://github.com/clice-io/clice/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ piyush-1337 ];
    mainProgram = "clice";
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
