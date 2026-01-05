{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  git,
  pkg-config,
  boost,
  eigen_3_4_0,
  glm,
  libGL,
  libpng,
  openexr,
  onetbb,
  xorg,
  ilmbase,
  llvmPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "curv";
  version = "0.5-unstable-2025-01-20";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "doug-moen";
    repo = "curv";
    rev = "ef082c6612407dd8abce06015f9a16b1ebf661b8";
    hash = "sha256-BGL07ZBA+ao3fg3qp56sVTe+3tM2SOp8TGu/jF7SVlM=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    boost
    eigen_3_4_0
    glm
    libGL
    libpng
    openexr
    onetbb
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

  # force char to be unsigned on aarch64
  # https://codeberg.org/doug-moen/curv/issues/227
  NIX_CFLAGS_COMPILE = [ "-fsigned-char" ];

  # GPU tests do not work in sandbox, instead we do this for sanity
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$(set -x; $out/bin/curv -x "2 + 2")" -eq "4"
    runHook postInstallCheck
  '';

  postPatch = ''
    substituteInPlace extern/googletest/googletest/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "2D and 3D geometric modelling programming language for creating art with maths";
    homepage = "https://codeberg.org/doug-moen/curv";
    license = licenses.asl20;
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "curv";
  };
}
