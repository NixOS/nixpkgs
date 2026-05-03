{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apfel-llm";
  version = "1.0.5";

  __structuredAttrs = true;
  strictDeps = true;

  # Building from source requires swift 6.3.0 while nixpkgs only has 5.10.1
  src = fetchurl {
    url = "https://github.com/Arthur-Ficial/apfel/releases/download/v${finalAttrs.version}/apfel-${finalAttrs.version}-arm64-macos.tar.gz";
    hash = "sha256-etEOYkYVPm08SRE3nuKcDigS7lCkUUgMacOl/sLv/1A=";
  };

  sourceRoot = ".";

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp apfel $out/bin/
    chmod +x $out/bin/apfel

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local Apple Intelligence LLM CLI and server";
    homepage = "https://github.com/Arthur-Ficial/apfel";
    changelog = "https://github.com/Arthur-Ficial/apfel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "apfel";
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
    ];
  };
})
