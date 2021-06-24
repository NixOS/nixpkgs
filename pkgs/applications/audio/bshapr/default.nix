{ lib, stdenv, fetchFromGitHub, xorg, cairo, lv2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "BShapr";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2DySlD5ZTxeQ2U++Dr67bek5oVbAiOHCxM6S5rTTZN0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BShapr";
    description = "Beat / envelope shaper LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
