{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  git,
  pkg-config,
  boost,
  eigen,
  glm,
  libGL,
  libpng,
  openexr,
  tbb,
  xorg,
  ilmbase,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "curv";
  version = "0.5-unstable-2025-01-06";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "doug-moen";
    repo = "curv";
    rev = "a496d98459b65d15feae8e69036944dafb7ec26e";
    hash = "sha256-2pe76fBU78xRvHxol8O1xv0bBVwbpKDVPLQqqUCTO0Y=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs =
    [
      boost
      eigen
      glm
      libGL
      libpng
      openexr
      tbb
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      ilmbase
      llvmPackages.openmp
    ];

  # GPU tests do not work in sandbox, instead we do this for sanity
  checkPhase = ''
    runHook preCheck
    test "$($out/bin/curv -x 2 + 2)" -eq "4"
    runHook postCheck
  '';

  meta = with lib; {
    description = "2D and 3D geometric modelling programming language for creating art with maths";
    homepage = "https://github.com/curv3d/curv";
    license = licenses.asl20;
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "curv";
  };
}
