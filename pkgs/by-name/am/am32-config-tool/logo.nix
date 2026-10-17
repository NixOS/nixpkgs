{
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  name = "am32-logo.svg";

  src = fetchFromGitHub {
    owner = "am32-firmware";
    repo = "am32-configurator";
    rev = "9cf7a8434b22d2d0d941c96fca1e3ed0661d2936";
    hash = "sha256-szlPKuVZldIV+J0o4a6SBOPEVvCnA9EaNuzW0uKAeRU=";
  };

  # Apply styling like how it's displayed at https://am32.ca/
  # Note: not exact, as the rounding radius depends on the browser default font size (why do you do this to me?!?!)
  postPatch = ''
    width=$(sed -n 's/.*width="\([0-9]\+\)".*/\1/p' assets/icons/am32-logo.svg)
    rx=$(( width * 16 / 180 ))
    sed -i -z "s|\(<svg[^>]*>\)|\1<rect width='100%' height='100%' fill='#991b1b' rx='$rx' ry='$rx'/>|" assets/icons/am32-logo.svg
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp assets/icons/am32-logo.svg $out

    runHook postInstall
  '';
})
