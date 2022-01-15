{ fetchFromGitHub
, lib
, stdenv
, cmake
, glib-networking
, gst_all_1
, gtkmm3
, libappindicator-gtk3
, pcre
, pkg-config
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "whatsapp-for-linux";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "eneshecan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TX6fMuhe6VHbhWJSsPM0iOV4CuCfULD5McJyHuTW4lI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib-networking
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtkmm3
    libappindicator-gtk3
    pcre
    webkitgtk
  ];

  meta = with lib; {
    homepage = "https://github.com/eneshecan/whatsapp-for-linux";
    description = "Whatsapp desktop messaging app";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bartuka ];
    platforms = [ "x86_64-linux" ];
  };
}
