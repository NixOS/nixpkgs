{
  fetchFromGitHub,
  lib,
  ncurses,
  gccStdenv,
}:
gccStdenv.mkDerivation {
  pname = "ascii-weather";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "asciiWeather";
    rev = "v1.0.0";
    hash = "sha256-8ntnVMQWeEO47gjP4G/GMCQ7NlsdjBsXU0+LMC6fr+U=";
  };
  buildInputs = [ ncurses ];
  installPhase = "install -D ascii-weather -t $out/bin";
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
