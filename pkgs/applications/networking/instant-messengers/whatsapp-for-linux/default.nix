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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "whatsapp-for-linux";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "eneshecan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dEJRufOqlY+DnJdUaG5WP9hR1qO7KxR6MjKWq1SJB8A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
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
