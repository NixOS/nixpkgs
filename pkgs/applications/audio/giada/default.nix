{ stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, fltk
, libsndfile
, libsamplerate
, jansson
, rtmidi
, xorg
, libjack2
, alsaLib
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "giada";
  version = "0.15.4";

  meta = with stdenv.lib;
    { description = "Hardcore loop machine";
      longDescription = ''
        Giada is a free, minimal, hardcore audio tool for DJs, live performers
        and electronic musicians. How does it work? Just pick up your channel,
        fill it with samples or MIDI events and start the show by using this
        tiny piece of software as a loop machine, drum machine, sequencer,
        live sampler or yet as a plugin/effect host.
      '';
      homepage = https://www.giadamusic.com;
      platforms = platforms.linux;
      license = lib.licenses.gpl3Plus;
    };

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = "giada";
    rev = "v${version}";
    sha256 = "17ggz04gczldhy2lf0v36bgc29dyjpjbxd0f3jj7y4sv2ya5bwv9";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    fltk
    libsndfile
    libsamplerate
    jansson
    rtmidi
    xorg.libXpm
    xorg.libXcursor
    xorg.libXinerama
    libjack2
    alsaLib
    libpulseaudio
  ];

  preConfigure = ''
    ${stdenv.shell} autogen.sh
  '';

  configureFlags = [
    "--target=linux"
    "--enable-system-catch"
  ];

  installPhase = ''
    install -Dm555 ./giada $out/bin/giada
  '';

  # you need to create $HOME/.giada/midimaps directory for midi assignment
  # to work correctly, Giada does not create this directory automatically.
}
