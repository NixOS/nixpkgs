{ stdenv, lib, fetchFromGitHub, python, makeWrapper
, eigen, fftw, libtiff, zlib, ants, bc
, qt5, libGL, libGLU, libX11, libXext
, withGui ? true }:

stdenv.mkDerivation rec {
  pname = "mrtrix";
  version = "3.0_RC3_latest";

  src = fetchFromGitHub {
    owner  = "MRtrix3";
    repo   = "mrtrix3";
    rev    = version;
    sha256 = "184nv524p8j94qicjy9l288bqcgl2yxqqs55a7042i0gfsnwp51c";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ eigen makeWrapper ] ++ lib.optional withGui qt5.wrapQtAppsHook;

  buildInputs = [
    ants
    python
    fftw
    libtiff
    zlib ] ++ lib.optionals withGui [
    libGL
    libGLU
    libX11
    libXext
    qt5.qtbase
    qt5.qtsvg
  ];

  installCheckInputs = [ bc ];

  postPatch = ''
    patchShebangs ./build ./configure ./run_tests ./bin/population_template
    substituteInPlace ./run_tests  \
      --replace 'git submodule update --init >> $LOGFILE 2>&1' ""
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

  installCheckPhase = "./run_tests";
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
      wrapProgram $prog --prefix PATH : ${lib.makeBinPath [ ants ]}
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
