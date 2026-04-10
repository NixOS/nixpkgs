{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  glib,
  json-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aseq2json";
  version = "0-unstable-2018-04-28";
  src = fetchFromGitHub {
    owner = "google";
    repo = "midi-dump-tools";
    rev = "8572e6313a0d7ec95492dcab04a46c5dd30ef33a";
    hash = "sha256-LQ9LLVumi3GN6c9tuMSOd1Bs2pgrwrLLQbs5XF+NZeA=";
  };
  sourceRoot = "${finalAttrs.src.name}/aseq2json";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    glib
    json-glib
  ];

  installPhase = ''
    install -D --target-directory "$out/bin" aseq2json
  '';

  meta = {
    description = "Listens for MIDI events on the Alsa sequencer and outputs as JSON to stdout";
    mainProgram = "aseq2json";
    homepage = "https://github.com/google/midi-dump-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ queezle ];
    platforms = lib.platforms.linux;
  };
})
