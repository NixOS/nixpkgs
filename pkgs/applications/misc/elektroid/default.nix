{ lib
, stdenv
, fetchFromGitHub
, gtk3
, wrapGAppsHook
, autoreconfHook
, pkg-config
, gettext
, json-glib
, automake
, autoconf
, libtool
, alsa-lib
, libpulseaudio
, libsndfile
, libsamplerate
, zlib
, libjson
, libzip
}:

stdenv.mkDerivation rec {
  pname = "elektroid";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "dagargo";
    repo = pname;
    rev = version;
    sha256 = "sha256-T7jxtmxlFe5WPC2KYDN6jDHwuVkmA6Y/h9qizZFH5rk=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    autoreconfHook
    pkg-config
    automake
    autoconf
    libtool
  ];

  buildInputs = [
    gtk3
    gettext
    json-glib
    alsa-lib
    libpulseaudio
    libsndfile
    libsamplerate
    zlib
    libjson
    libzip
  ];

  meta = with lib; {
    description = "Transfer application for Elektron devices";
    homepage = "https://github.com/dagargo/elektroid";
    maintainers = with maintainers; [ dag-h ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

