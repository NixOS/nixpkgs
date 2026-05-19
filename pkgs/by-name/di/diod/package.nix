{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  munge,
  lua5_1,
  libcap,
  perl,
  ncurses,
}:
let
  lua = lua5_1;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "diod";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "chaos";
    repo = "diod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fz+qvgw5ipyAcZlWBGkmSHuGrZ95i5OorLN3dkdsYKU=";
  };

  postPatch = ''
    sed -i configure.ac -e '/git describe/c ${finalAttrs.version})'
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    munge
    lua
    libcap
    perl
    ncurses
  ];

  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system/"
    "--sysconfdir=/etc"
  ];

  meta = {
    description = "I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
