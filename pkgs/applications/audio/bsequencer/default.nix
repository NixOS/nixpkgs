{ lib, stdenv, fetchFromGitHub, xorg, cairo, lv2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "BSEQuencer";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "sha256-PZ2Ft7y2mbb5Wpa7mWPys2BVpcQC3WE5rKu2sRqkf8w=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BSEQuencer";
    description = "Multi channel MIDI step sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
