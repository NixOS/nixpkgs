{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "convfont";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "drdnar";
    repo = "convfont";
    rev = "a4f90539165ef15e391ad8cf26a14d4876072dc8";
    sha256 = "sha256-xDn29/HETeao0cwvt2LohA37sGQQ20gtBdYr20vA04A=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    install -Dm755 convfont $out/bin/convfont
  '';

  meta = with lib; {
    description = "Converts font for use with FontLibC";
    homepage = "https://github.com/drdnar/convfont";
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    mainProgram = "convfont";
  };
}
