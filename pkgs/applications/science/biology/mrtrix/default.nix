{ stdenv, lib, fetchFromGitHub, python, makeWrapper
, eigen, fftw, libtiff, libpng, zlib, ants, bc
, qt5, libGL, libGLU, libX11, libXext
, withGui ? true }:

stdenv.mkDerivation rec {
  pname = "mrtrix";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner  = "MRtrix3";
    repo   = "mrtrix3";
    rev    = version;
    sha256 = "1vvmmbw3m0bdfwp4szr62ygzsvkj0ss91cx5zlkspsr1rff05f9b";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ eigen makeWrapper ] ++ lib.optional withGui qt5.wrapQtAppsHook;

  buildInputs = [
    ants
    python
    fftw
    libtiff
    libpng
    zlib
  ] ++ lib.optionals withGui [
    libGL
    libGLU
    libX11
    libXext
    qt5.qtbase
    qt5.qtsvg
  ];

  installCheckInputs = [ bc ];

  postPatch = ''
    patchShebangs ./build ./configure ./run_tests ./bin/*

    # patching interpreters before fixup is needed for tests:
    patchShebangs ./bin/*
    patchShebangs testing/binaries/data/vectorstats/*py

    substituteInPlace ./run_tests  \
      --replace 'git submodule update --init $datadir >> $LOGFILE 2>&1' ""
  '';

  configurePhase = ''
    export EIGEN_CFLAGS="-isystem ${eigen}/include/eigen3"
    unset LD  # similar to https://github.com/MRtrix3/mrtrix3/issues/1519
    ./configure ${lib.optionalString (!withGui) "-nogui"};
  '';

  buildPhase = ''
    ./build
    (cd testing && ../build)
  '';

  installCheckPhase = ''
    ./run_tests units
    ./run_tests binaries

    # can also `./run_tests scripts`, but this fails due to lack of FSL package
    # (and there's no convenient way to disable individual tests)
  '';
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -ar lib $out/lib
    cp -ar bin $out/bin
    runHook postInstall
  '';

  postInstall = ''
    for prog in $out/bin/*; do
      if [[ -x "$prog" ]]; then
        wrapProgram $prog --prefix PATH : ${lib.makeBinPath [ ants ]}
      fi
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/MRtrix3/mrtrix3";
    description = "Suite of tools for diffusion imaging";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license   = licenses.mpl20;
  };
}
