{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "snis_assets";
  version = "2025-07-26";

  src = fetchFromGitHub {
    owner = "marcin-serwin";
    repo = "snis-assets-snapshotter";
    tag = finalAttrs.version;
    hash = "sha256-K/X66txXKpGtWPRtWXvKiVMYb6vGJtrv2CdHVuXbT8M=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r share $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Assets for Space Nerds In Space, a multi-player spaceship bridge simulator";
    homepage = "https://smcameron.github.io/space-nerds-in-space/";
    downloadPage = "https://github.com/marcin-serwin/snis-assets-snapshotter";
    license = with lib.licenses; [
      gpl2Plus
      cc-by-sa-30
      cc-by-40
      cc-by-30
      cc0
      publicDomain
      free
    ];
    maintainers = with lib.maintainers; [
      pentane
      marcin-serwin
    ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
})
