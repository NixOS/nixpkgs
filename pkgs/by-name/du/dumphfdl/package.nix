{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  cmake,
  pkg-config,
  libconfig,
  liquid-dsp,
  fftwSinglePrec,
  glib,
  soapysdr-with-plugins,
  sqlite,
  zeromq,
  gperftools,
  libacars,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dumphfdl";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = "dumphfdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M4WjcGA15Kp+Hpp+I2Ndcx+oBqaGxEeQLTPcSlugLwQ=";
  };

  buildInputs = [
    fftwSinglePrec
    liquid-dsp
    glib
    libconfig
    soapysdr-with-plugins
    sqlite
    zeromq
    gperftools
    libacars
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/szpajder/dumphfdl";
    changelog = "https://github.com/szpajder/dumphfdl/releases/tag/v${finalAttrs.version}";
    description = "Decoder for Multichannel HFDL aircraft communication";
    longDescription = ''
      HFDL (High Frequency Data Link) is a protocol used for radio communications
      between aircraft and ground stations. It is used to carry ACARS and AOC messages as well as
      CPDLC (Controller-Pilot Data Link Communications) and ADS-C.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "dumphfdl";
    maintainers = [ lib.maintainers.mafo ];
    platforms = with lib.platforms; linux ++ darwin;
    badPlatforms = lib.platforms.darwin;
  };
})
