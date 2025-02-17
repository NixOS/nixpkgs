{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchDebianPatch,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "libcli";
  version = "1.10.7";

  src = fetchFromGitHub {
    owner = "dparrish";
    repo = "libcli";
    rev = "V${version}";
    hash = "sha256-ItmZfclx2mprKUOk/MwlS2w4f0ukiiPA5/QaRdGfEO8=";
  };

  patches = [
    (fetchDebianPatch {
      pname = "libcli";
      version = "1.10.7";
      debianRevision = "2";
      patch = "02-fix-transposed-calloc-args";
      hash = "sha256-lSZeg5h+LUIGa4DnkAmwIEs+tctCYs/tuY63hbBUjuw=";
    })
  ];

  buildInputs = [
    libxcrypt
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Emulate a Cisco-style telnet command-line interface";
    homepage = "https://dparrish.com/pages/libcli";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.linux;
  };
}
