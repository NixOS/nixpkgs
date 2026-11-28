# NOTE: Use the following command to update the package
# ```sh
# nix-shell maintainers/scripts/update.nix --arg commit true --arg predicate '(path: pkg: builtins.elem path [["qoder-cli-cn"]])'
# ```
{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  cctools,
  darwin,
  rcodesign,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  manifest ? lib.importJSON ./manifest.json,
}:
let
  # Upstream ships one tarball per os/arch pair, listed in its release manifest.
  # The plain `amd64` Linux build requires AVX2 and other CPU features, so use
  # the baseline build to keep x86_64-linux working on every supported CPU.
  upstreamPlatform =
    {
      x86_64-linux = {
        os = "linux";
        arch = "amd64-baseline";
      };
      aarch64-linux = {
        os = "linux";
        arch = "arm64";
      };
      x86_64-darwin = {
        os = "darwin";
        arch = "amd64";
      };
      aarch64-darwin = {
        os = "darwin";
        arch = "arm64";
      };
    }
    .${stdenvNoCC.hostPlatform.system};

  manifestEntry =
    lib.findFirst (file: file.os == upstreamPlatform.os && file.arch == upstreamPlatform.arch)
      (throw "qoder-cli-cn ${manifest.latest} has no ${upstreamPlatform.os}/${upstreamPlatform.arch} release")
      manifest.files;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "qoder-cli-cn";
  version = manifest.latest;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    inherit (manifestEntry) url sha256;
  };

  sourceRoot = ".";

  dontStrip = true;

  nativeBuildInputs =
    lib.optionals stdenvNoCC.hostPlatform.isElf [ autoPatchelfHook ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
      cctools
      darwin.ICU
      rcodesign
    ];

  installPhase = ''
    runHook preInstall

    install -Dm755 qoderclicn -t $out/bin

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    '${lib.getExe' cctools "${cctools.targetPrefix}install_name_tool"}' $out/bin/qoderclicn \
      -change /usr/lib/libicucore.A.dylib '${lib.getLib darwin.ICU}/lib/libicucore.A.dylib'
    '${lib.getExe rcodesign}' sign --code-signature-flags linker-signed $out/bin/qoderclicn
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal";
    homepage = "https://qoder.com.cn";
    downloadPage = "https://qoder.com.cn/install";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ Freed-Wu ];
    mainProgram = "qoderclicn";
  };
})
