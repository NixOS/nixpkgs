{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  perl,
  fribidi,
  kbd,
  xkbutils,
}:

stdenv.mkDerivation rec {
  pname = "bicon";
  version = "unstable-2020-06-04";

  src = fetchFromGitHub {
    owner = "behdad";
    repo = pname;
    rev = "64ae10c94b94a573735a2c2b1502334b86d3b1f7";
    sha256 = "0ixsf65j4dbdl2aazjc2j0hiagbp6svvfwfmyivha0i1k5yx12v1";
  };

  patches = [
    # Fix build on clang-13. Pull the change pending upstream
    # inclusion: https://github.com/behdad/bicon/pull/29
    (fetchpatch {
      name = "clang.patch";
      url = "https://github.com/behdad/bicon/commit/20f5a79571f222f96e07d7c0c5e76e2c9ff1c59a.patch";
      sha256 = "0l1dm7w52k57nv3lvz5pkbwp021mlsk3csyalxi90np1lx5sqbd1";
    })
  ];

  buildInputs = [
    fribidi
    kbd
    xkbutils
    perl
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with lib; {
    description = "Bidirectional console";
    homepage = "https://github.com/behdad/bicon";
    license = [
      licenses.lgpl21
      licenses.psfl
      licenses.bsd0
    ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
