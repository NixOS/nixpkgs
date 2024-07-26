{ lib, stdenv, fetchFromGitHub, lv2, pkg-config }:

stdenv.mkDerivation rec {

  pname = "mod-arpeggiator-lv2";
  version = "unstable-2021-11-09";

  src = fetchFromGitHub {
    owner = "moddevices";
    repo = pname;
    rev = "82f3d9f159ce216454656a8782362c3d5ed48bed";
    sha256 = "sha256-1KiWMTVTTf1/iR4AzJ1Oe0mOrWN5edsZN0tQMidgnRA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "a LV2 arpeggiator";
    homepage = "https://github.com/moddevices/mod-arpeggiator-lv2";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
