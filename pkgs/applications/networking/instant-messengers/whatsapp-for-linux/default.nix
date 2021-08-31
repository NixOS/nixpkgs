{ fetchFromGitHub
, lib
, stdenv
, gtkmm3
, webkitgtk
, cmake
, pkg-config
, libappindicator-gtk3
, gst_all_1
, pcre
}:

stdenv.mkDerivation rec {
  pname = "whatsapp-for-linux";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eneshecan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dB+NsoUEYM3cT0cg5ZOkBGW7ozRGFWSsYQMja3CjaHM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtkmm3
    webkitgtk
    libappindicator-gtk3
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    pcre
  ];

  meta = with lib; {
    homepage = "https://github.com/eneshecan/whatsapp-for-linux";
    description = "Whatsapp desktop messaging app";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bartuka ];
    platforms = [ "x86_64-linux" ];
  };
}
