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
  fetchpatch,
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

  patches = [
    # fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://github.com/chaos/diod/commit/d56db0c55012c8a9ea2d3c72749022292c0f65b8.patch";
      hash = "sha256-wuPok3D3VKiao9NmHYLcccsL+91xVbhUeSDExw17X/E=";
    })
  ];

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
    homepage = "https://github.com/chaos/diod";
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
