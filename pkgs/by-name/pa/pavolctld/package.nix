{
  lib,
  fetchzip,
  libpulseaudio,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "pavolctld";
  version = "1.0.1";

  src = fetchzip {
    url = "https://git.tjkeller.xyz/${pname}/snapshot/${pname}-${version}.tar.xz";
    sha256 = "sha256-nmN8bQKQNGpCGvHQnZK9YQgB80SxRSds0V9Y7h/Guh8=";
  };

  buildInputs = [ libpulseaudio ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A minimal volume control/monitoring daemon for PulseAudio and PipeWire";
    homepage = "https://tjkeller.xyz/projects/pavolctld";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.tjkeller ];
  };
}
