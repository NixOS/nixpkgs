{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  git,
  pkg-config,
  boost188,
  eigen_5,
  glm,
  gcc,
  libGL,
  libpng,
  makeWrapper,
  openexr,
  onetbb,
  libxrandr,
  libxi,
  libxinerama,
  libxext,
  libxcursor,
  libx11,
  ilmbase,
  llvmPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "curv";
  version = "0.5-unstable-2026-02-26";

  src = fetchFromCodeberg {
    owner = "doug-moen";
    repo = "curv";
    rev = "bf573da133f94efacc6a42c9dc94666bfbfab6bc";
    hash = "sha256-5tcF0vEvxd/SgNWM7lgZTujBsIF+v8t0I0g4tykBCPY=";
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
    boost188
    eigen_5
    glm
    libGL
    libpng
    openexr
    onetbb
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ilmbase
    llvmPackages.openmp
  ];

  # force char to be unsigned on aarch64
  # https://codeberg.org/doug-moen/curv/issues/227
  env.NIX_CFLAGS_COMPILE = toString [ "-fsigned-char" ];

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
    # aarch64 fails installCheckPhase: https://hydra.nixos.org/build/319705783
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "curv";
  };
}
