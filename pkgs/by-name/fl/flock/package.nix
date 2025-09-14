{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  ronn,
}:

stdenv.mkDerivation rec {
  pname = "flock";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "discoteq";
    repo = "flock";
    rev = "v${version}";
    sha256 = "sha256-cCpckORtogs6Nt7c5q2+z0acXAnALdLV6uzxa5ng3s4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    ronn
  ];

  patches = [
    (fetchpatch {
      name = "fix-format-specifier.patch";
      url = "https://github.com/discoteq/flock/commit/408bad42eb8d76cdd0c504c2f97f21c0b424c3b1.patch";
      sha256 = "sha256-YuFKXWTBu9A2kBNqkg1Oek6vDbVo/y8dB1k9Fuh3QmA";
    })
  ];

  meta = {
    description = "Cross-platform version of flock(1)";
    homepage = "https://github.com/discoteq/flock";
    maintainers = with lib.maintainers; [ matthewbauer ];
    mainProgram = "flock";
    platforms = lib.platforms.all;
    license = lib.licenses.isc;
  };
}
