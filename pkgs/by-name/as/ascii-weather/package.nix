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
  buildInputs = [
    gcc
    gnumake
    ncurses
  ];
  buildPhase = "make build";
  installPhase = ''
    mkdir -p $out/bin
    cp ascii-weather $out/bin
  '';
  meta = {
    description = "An ASCII-based screensaver that shows various weather conditions";
    longDescription = ''
      This screensaver uses ASCII art to display different weather types.
      It's a creative and simple way to keep your terminal lively while providing weather updates.
    '';
    homepage = "https://github.com/NewDawn0/asciiWeather";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
