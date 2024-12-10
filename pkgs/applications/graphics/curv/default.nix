{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
  version = "0.5";

  src = fetchFromGitHub {
    owner = "curv3d";
    repo = "curv";
    rev = "refs/tags/${version}";
    hash = "sha256-m4p5uxRk6kEJUilmbQ1zJcQDRvRCV7pkxnqupZJxyjo=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
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
    ++ lib.optionals stdenv.isDarwin [
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
    description = "A 2D and 3D geometric modelling programming language for creating art with maths";
    homepage = "https://github.com/curv3d/curv";
    license = licenses.asl20;
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "curv";
  };
}
