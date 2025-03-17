{
  lib,
  stdenv,
  fetchgit,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pavolctld";
  version = "1.0.1";

  src = fetchgit {
    url = "https://git.tjkeller.xyz/pavolctld";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nmN8bQKQNGpCGvHQnZK9YQgB80SxRSds0V9Y7h/Guh8=";
  };

  buildInputs = [ libpulseaudio ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Minimal volume control/monitoring daemon for PulseAudio and PipeWire";
    homepage = "https://tjkeller.xyz/projects/pavolctld";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tjkeller ];
    mainProgram = "pavolctld";
  };
})
