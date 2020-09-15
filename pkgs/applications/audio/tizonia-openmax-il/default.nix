{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, which, makeWrapper
, SDL, bash-completion , boost, curl, dbus, faad2, flac, lame, libev
, libfishsound, libmad , libmediainfo, liboggz, libopus, libpulseaudio
, libsndfile, libspotify , libuuid, libvpx, libzen, log4c, mpg123, opusfile
, python3, sqlite, taglib
}:

stdenv.mkDerivation rec {
  pname = "tizonia-openmax-il";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "tizonia";
    repo = pname;
    rev = "v${version}";
    sha256 = "059iml5l9d7izhvci1f6piwbprzfrk12315pkifhyzbyxcd5fny9";
  };

  preConfigure = ''
    export BOOST_INCLUDEDIR="${stdenv.lib.getDev boost}/include";
    export BOOST_LIBRARYDIR="${stdenv.lib.getLib boost}/lib";
  '';

  prePatch = ''
    substituteInPlace player/src/tizplayapp.cpp \
      --replace '"/etc/tizonia/tizonia.conf"' "\"$out/etc/tizonia/tizonia.conf\""
  '';

  mesonFlags = [ "-Dbashcompletiondir=${placeholder "out"}/share/bash-completion" ];

  nativeBuildInputs = [ meson ninja pkg-config which ];

  buildInputs = [
    SDL bash-completion boost curl.dev dbus.dev faad2 flac.dev lame libev
    libfishsound libmad libmediainfo liboggz libopus libpulseaudio.dev
    libsndfile libspotify libuuid.dev libvpx libzen log4c mpg123 opusfile
    python3 sqlite.dev taglib
  ];

  meta = with stdenv.lib; {
    description = "Command-line streaming music client/server for Linux";
    longDescription = ''
      Includes support for Spotify (Premium), Google Play Music (free and paid
      tiers), YouTube, SoundCloud, TuneIn and iHeart Internet Radio
      directories, Plex servers and Chromecast devices.
    '';
    homepage = "https://tizonia.org/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.wucke13 ];
    platforms = platforms.linux;
  };
}
