{ fetchFromGitHub
, lib
, stdenv
, cmake
, glib-networking
, gst_all_1
, gtkmm3
, libayatana-appindicator
, libcanberra
, libepoxy
, libpsl
, libdatrie
, libdeflate
, libselinux
, libsepol
, libsysprof-capture
, libthai
, libxkbcommon
, sqlite
, pcre
, pcre2
, pkg-config
, webkitgtk
, wrapGAppsHook
, xorg
}:

stdenv.mkDerivation rec {
  pname = "whatsapp-for-linux";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "eneshecan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-odE5syAFasGosc1WMU/pvQtk3YxuCci1YevZqNKfzYw=";
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
    libayatana-appindicator
    libcanberra
    libdatrie
    libdeflate
    libepoxy
    libpsl
    libselinux
    libsepol
    libsysprof-capture
    libthai
    libxkbcommon
    pcre
    pcre2
    sqlite
    webkitgtk
    xorg.libXdmcp
    xorg.libXtst
  ];

  meta = with lib; {
    homepage = "https://github.com/eneshecan/whatsapp-for-linux";
    description = "Whatsapp desktop messaging app";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bartuka ];
    platforms = [ "x86_64-linux" ];
  };
}
