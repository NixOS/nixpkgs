{
  lib,
  stdenv,
  fetchFromGitHub,
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

  meta = with lib; {
    description = "Assets for Space Nerds In Space, a multi-player spaceship bridge simulator";
    homepage = "https://smcameron.github.io/space-nerds-in-space/";
    license = [
      licenses.cc-by-sa-30
      licenses.cc-by-30
      licenses.cc0
      licenses.publicDomain
    ];
    maintainers = with maintainers; [ pentane ];
    platforms = platforms.linux;
    hydraPlatforms = [ ];
  };
})
