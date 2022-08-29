{ stdenv, lib
, alsa-utils
, at-spi2-core
, cmake
, curl
, dbus
, fetchFromGitHub
, flac
, gtk3
, jasper
, libGLU
, libarchive
, libdatrie
, libelf
, libepoxy
, libexif
, libogg
, libopus
, libselinux
, libsepol
, libsndfile
, libthai
, libunarr
, libusb1
, libvorbis
, libxkbcommon
, lsb-release
, lz4
, pcre
, pkg-config
, portaudio
, sqlite
, tinyxml
, udev
, util-linux
, wxGTK31-gtk3
, xorg
}:

stdenv.mkDerivation rec {
  pname = "opencpn";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "OpenCPN";
    repo = "OpenCPN";
    rev = "Release_${version}";
    hash = "sha256-sNZYf/2gtjRrrGPuazVnKTgcuIQpKPazhexqlK21T4g=";
  };

  nativeBuildInputs = [ cmake lsb-release pkg-config ];
  buildInputs = [
    alsa-utils
    at-spi2-core
    curl
    dbus
    flac
    gtk3
    jasper
    libGLU
    libarchive
    libdatrie
    libelf
    libepoxy
    libexif
    libogg
    libopus
    libselinux
    libsepol
    libsndfile
    libthai
    libunarr
    libusb1
    libvorbis
    libxkbcommon
    lz4
    pcre
    portaudio
    sqlite
    tinyxml
    udev
    util-linux
    wxGTK31-gtk3
    xorg.libXdmcp
    xorg.libXtst
  ];


  cmakeFlags = [ "-DOCPN_BUNDLE_DOCS=true" ];

  doCheck = true;

  meta = with lib; {
    description = "A concise ChartPlotter/Navigator";
    maintainers = with maintainers; [ kragniz lovesegfault ];
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl2;
    homepage = "https://opencpn.org/";
  };
}
