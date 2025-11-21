{
  runCommand,
  fetchurl,
  lib,
}:
runCommand "glasstty-ttf"
  {
    src = fetchurl {
      url = "https://github.com/svofski/glasstty/raw/2c47ac1a0065f8b12d9732257993833d8227e3e5/Glass_TTY_VT220.ttf";
      sha256 = "sha256-2NYJaSWNr1Seuqdd7nLjA7tAMs/SAvl3uAe3uDoLLO4=";
    };
    meta = {
      maintainers = [ lib.maintainers.pkharvey ];
      homepage = "https://github.com/svofski/glasstty";
      license = lib.licenses.unlicense;
      platforms = lib.platforms.all;
      description = "TrueType VT220 font";
    };
  }
  ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/Glass_TTY_VT220.ttf
  ''
