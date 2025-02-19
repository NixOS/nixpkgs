{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  boost,
  codec2,
}:

stdenv.mkDerivation rec {
  pname = "m17-cxx-demod";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "mobilinkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mvppkFBmmPVqvlqIqrbwGrOBih5zS5sZrV/usEhHiws=";
  };

  patches = [
    # Pull fix pending upstream inclusion for `gcc-13` support:
    #   https://github.com/mobilinkd/m17-cxx-demod/pull/34
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/mobilinkd/m17-cxx-demod/commit/2e2aaf95eeac456a2e8795e4363518bb4d797ac0.patch";
      hash = "sha256-+XRzHStJ/7XI5JDoBeNwbifsTOw8il3GyFwlbw07wyk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    codec2
    boost
  ];

  meta = with lib; {
    description = "M17 Demodulator in C++";
    homepage = "https://github.com/mobilinkd/m17-cxx-demod";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = teams.c3d2.members;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
