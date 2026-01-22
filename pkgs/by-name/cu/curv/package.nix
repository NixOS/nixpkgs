{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  git,
  pkg-config,
  boost,
  eigen_5,
  glm,
  gcc,
  libGL,
  libpng,
  makeWrapper,
  openexr,
  onetbb,
  xorg,
  ilmbase,
  llvmPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "curv";
  version = "0.5-unstable-2026-01-17";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "doug-moen";
    repo = "curv";
    rev = "1c2eb68e47e3c61a98e39cd3c50f90691c5a268d";
    hash = "sha256-PuRBnJswrg+PjtU6ize+PjoBpQSSEzO2CeCx9mQF+3w=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    git
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    boost
    eigen_5
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

  ## support runtime compilation with -Ojit
  fixupPhase = ''
    wrapProgram $out/bin/curv \
      --set NIX_CFLAGS_COMPILE_${gcc.suffixSalt} "$NIX_CFLAGS_COMPILE" \
      --set NIX_LDFLAGS_${gcc.suffixSalt} "$NIX_LDFLAGS" \
      --prefix PATH : "${
        lib.makeBinPath [
          gcc
        ]
      }"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "2D and 3D geometric modelling programming language for creating art with maths";
    homepage = "https://codeberg.org/doug-moen/curv";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "curv";
  };
}
