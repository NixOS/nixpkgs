{
  lib,
  stdenv,
  fetchgit,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pavolctld";
  version = "1.0.2";

  src = fetchgit {
    url = "https://git.tjkeller.xyz/pavolctld";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gNEXED+9BkCCLi8oW2GZi9Azd/zOWUvu/bY0a1WbE/A=";
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
