{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pagemon";
  version = "0.02.05";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "pagemon";
    tag = "V${finalAttrs.version}";
    hash = "sha256-Crr1312wZ1IIwvODAUooZ0Lr75W0qdDQrr1sszaNHa4=";
  };

  buildInputs = [ ncurses ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man/man8"
    "BASHDIR=$(out)/share/bash-completion/completions"
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Interactive memory/page monitor for Linux";
    mainProgram = "pagemon";
    longDescription = ''
      pagemon is an ncurses based interactive memory/page monitoring tool
      allowing one to browse the memory map of an active running process
      on Linux.
      pagemon reads the PTEs of a given process and display the soft/dirty
      activity in real time. The tool identifies the type of memory mapping
      a page belongs to, so one can easily scan through memory looking at
      pages of memory belonging data, code, heap, stack, anonymous mappings
      or even swapped-out pages.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
