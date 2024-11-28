{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, zlib
, gtest
, eigen
}:

stdenv.mkDerivation rec {
  pname = "lc0";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "LeelaChessZero";
    repo = "lc0";
    rev = "refs/tags/v${version}";
    hash = "sha256-VbWNc41CgsS0I64QHNp+k9cM/IEai9b3SyHorfmwvsE=";
    fetchSubmodules = true;
  };

  patchPhase = ''
    runHook prePatch

    patchShebangs --build scripts/*

    runHook postPatch
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    eigen
    gtest
    zlib
  ];

  mesonFlags = [
    "-Dplain_cuda=false"
    "-Daccelerate=false"
    "-Dmetal=disabled"
    "-Dembed=false"
  ]
  # in version 31 this option will be required
  ++ lib.optionals (lib.versionAtLeast version "0.31") [ "-Dnative_cuda=false" ];


  enableParallelBuilding = true;

  meta = {
    homepage = "https://lczero.org/";
    description = "Open source neural network based chess engine";
    longDescription = ''
      Lc0 is a UCI-compliant chess engine designed to play chess via neural network, specifically those of the LeelaChessZero project.
    '';
    maintainers = with lib.maintainers; [ _9glenda ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
    broken = stdenv.hostPlatform.isDarwin;
  };

}
