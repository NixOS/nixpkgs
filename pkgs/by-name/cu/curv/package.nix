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
    tag = version;
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

  meta = {
    description = "2D and 3D geometric modelling programming language for creating art with maths";
    homepage = "https://github.com/curv3d/curv";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "curv";
  };
}
