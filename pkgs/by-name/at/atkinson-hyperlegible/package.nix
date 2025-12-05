{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-hyperlegible";
  version = "0-unstable-2021-04-29";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "atkinson-hyperlegible";
    rev = "1cb311624b2ddf88e9e37873999d165a8cd28b46";
    hash = "sha256-RN4m5gyY2OiPzRXgFVQ3pq6JdkPcMxV4fRlX2EK+gOM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype fonts/otf/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Typeface designed to offer greater legibility and readability for low vision readers";
    homepage = "https://brailleinstitute.org/freefont";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
