{
  fetchFromGitHub,
  gcc,
  gnumake,
  lib,
  ncurses,
  stdenv,
}:
stdenv.mkDerivation {
  name = "ascii-weather";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "asciiWeather";
    rev = "70bf111647d064c3fcd0fe672b9fa697f4d060e4";
    hash = "sha256-Dcosx6iEnvFCMrmUS7gSLg8re5zl1BXWX/Nu6hr4Pgw=";
  };
  buildInputs = [gcc gnumake ncurses];
  buildPhase = "make build";
  installPhase = ''
    mkdir -p $out/bin
    cp ascii-weather $out/bin
  '';
  meta = with lib; {
    description = "An ascii screensaver displaying different weather types";
    homepage = "https://github.com/NewDawn0/asciiWeather";
    license = licenses.mit;
    maintainers = [NewDawn0];
    platforms = platforms.all;
  };
}
