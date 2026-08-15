{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "auge";
  version = "1.9.0";

  __structuredAttrs = true;
  strictDeps = true;

  # Building from source requires swift 6.3.0 while nixpkgs only has 5.10.1
  src = fetchurl {
    url = "https://github.com/Arthur-Ficial/auge/releases/download/v${finalAttrs.version}/auge-${finalAttrs.version}-arm64-macos.tar.gz";
    hash = "sha256-hL3kq1/hFo4rlq2nz4iaRLqoErLiF032ovqwl5Rwqso=";
  };

  sourceRoot = ".";

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp auge $out/bin/
    chmod +x $out/bin/auge

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "On-device Apple Vision framework CLI";
    homepage = "https://github.com/Arthur-Ficial/auge";
    changelog = "https://github.com/Arthur-Ficial/auge/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "auge";
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
    ];
  };
})
