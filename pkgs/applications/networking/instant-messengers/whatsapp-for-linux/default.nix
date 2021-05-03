{ fetchFromGitHub, lib, stdenv, gnome3, cmake, pkg-config,
  libappindicator-gtk3, gst_all_1, pcre }:

stdenv.mkDerivation rec {
  pname = "whatsapp-for-linux";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "eneshecan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gzahls4givd2kbjdwx6yb3jv7a3r1krw40qihiz7hkamkrpaiaz";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gnome3.gtkmm
    gnome3.webkitgtk
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
