{
  fetchFromGitHub,
  lib,
  stdenv,
  makeWrapper,
  xorg,
  ncurses,
  coreutils,
  bashInteractive,
  gnused,
  gnugrep,
  glibc,
  xterm,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "bashrun2";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "hbekel";
    repo = "bashrun2";
    tag = "v${version}";
    hash = "sha256-U2ntplhyv8KAkaMd2D6wRsUIYkhJzxdgHo2xsbNRfqM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    xorg.libX11
  ];

  patches = [
    ./remote-permissions.patch
  ];

  postPatch = ''
    substituteInPlace \
      man/bashrun2.1 \
      --replace-fail '/usr/bin/brwctl' "$out/bin/brwctl"

    substituteInPlace \
      src/bindings \
      src/registry \
      src/utils \
      src/bashrun2 \
      src/frontend \
      src/remote \
      src/plugin \
      src/engine \
      src/bookmarks \
      --replace-fail '/bin/rm' '${coreutils}/bin/rm'

    substituteInPlace \
      src/bashrun2 \
      --replace-fail '#!/usr/bin/env bash' '#!${lib.getExe bashInteractive}'

    substituteInPlace \
      src/remote \
      --replace-fail '/bin/cp' '${coreutils}/bin/cp'
  '';

  postFixup = ''
    wrapProgram $out/bin/bashrun2 \
      --prefix PATH : "$out/bin:${
        lib.makeBinPath [
          ncurses
          coreutils
          gnused
          gnugrep
          glibc
          bashInteractive
          xterm
          util-linux
        ]
      }" \
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"
  '';

  meta = {
    maintainers = with lib.maintainers; [ dopplerian ];
    mainProgram = "bashrun2";
    homepage = "http://henning-liebenau.de/bashrun2/";
    license = lib.licenses.gpl2Plus;
    description = "Application launcher based on a modified bash session in a small terminal window";
  };
}
