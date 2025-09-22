{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
  eigen_3_4_0,
  fftw,
  libtiff,
  libpng,
  zlib,
  ants,
  bc,
  qt5,
  libGL,
  libGLU,
  libX11,
  libXext,
  less,
  withGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mrtrix";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "MRtrix3";
    repo = "mrtrix3";
    rev = finalAttrs.version;
    hash = "sha256-cPI6Ac1Yp5yb07zv9r5O7ZbsHpjrv5BkzbAW1qgj3gQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
    less
    python3
  ]
  ++ lib.optional withGui qt5.wrapQtAppsHook;

  buildInputs = [
    ants
    eigen_3_4_0
    python3
    fftw
    libtiff
    libpng
    zlib
  ]
  ++ lib.optionals withGui [
    libGL
    libGLU
    libX11
    libXext
    qt5.qtbase
    qt5.qtsvg
  ];

  nativeInstallCheckInputs = [ bc ];

  postPatch = ''
    patchShebangs --build ./build ./configure ./run_tests
    patchShebangs --host ./bin/*

    # patching interpreters before fixup is needed for tests:
    patchShebangs testing/binaries/data/vectorstats/*py

    substituteInPlace ./run_tests  \
      --replace-fail 'git submodule update --init $datadir >> $LOGFILE 2>&1' ""

    # reduce build noise
    substituteInPlace ./configure \
      --replace-fail "[ '-Wall' ]" "[]"

    # fix error output (cuts off after a few lines otherwise)
    substituteInPlace ./build  \
      --replace-fail 'stderr=subprocess.PIPE' 'stderr=None'
  '';

  configurePhase = ''
    runHook preConfigure
    export EIGEN_CFLAGS="-isystem ${eigen_3_4_0}/include/eigen3"
    unset LD  # similar to https://github.com/MRtrix3/mrtrix3/issues/1519
    ./configure ${lib.optionalString (!withGui) "-nogui"};
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ./build
    (cd testing && ../build)
    runHook postBuild
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    ./run_tests units
    ./run_tests binaries

    # can also `./run_tests scripts`, but this fails due to lack of FSL package
    # (and there's no convenient way to disable individual tests)
    runHook postInstallCheck
  '';
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -ar lib $out/lib
    cp -ar bin $out/bin
    runHook postInstall
  '';

  preFixup =
    if withGui then
      ''
        qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ants ]})
      ''
    else
      ''
        for prog in $out/bin/*; do
          if [[ -x "$prog" ]]; then
            wrapProgram $prog --prefix PATH : ${lib.makeBinPath [ ants ]}
          fi
        done
      '';

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://github.com/MRtrix3/mrtrix3";
    description = "Suite of tools for diffusion imaging";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.mpl20;
  };
})
