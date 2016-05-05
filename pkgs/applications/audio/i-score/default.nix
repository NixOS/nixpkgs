{
  boost,
  cln,
  cmake,
  fetchgit,
  gcc5,
  ginac,
  jamomacore,
  kde5,
  libsndfile,
  ninja,
  portaudio,
  qtbase,
  qtdeclarative,
  qtimageformats,
  qtsvg,
  qttools,
  qtwebsockets,
  rtaudio,
  stdenv
}:

stdenv.mkDerivation rec {
  version = "1.0.0-a67";
  name = "i-score-${version}";

  src = fetchgit {
    url = "https://github.com/OSSIA/i-score.git";
    rev = "ede2453b139346ae46702b5e2643c5488f8c89fb";
    sha256 = "04li771nj0k8gym7vg6rnawjkp2f6d5m5mby26h0k6ksf7hg7h70";
    leaveDotGit = true;
    deepClone = true;
  };

  buildInputs = [
    boost
    cln
    cmake
    ginac
    gcc5
    jamomacore
    kde5.kdnssd
    libsndfile
    ninja
    portaudio
    qtbase
    qtdeclarative
    qtimageformats
    qtsvg
    qttools
    qtwebsockets
    rtaudio
  ];

  cmakeFlags = [
    "-GNinja"
    "-DISCORE_CONFIGURATION=static-release"
    "-DISCORE_ENABLE_LTO=OFF"
    "-DISCORE_BUILD_FOR_PACKAGE_MANAGER=True"
  ];

  patchPhase = ''
    sed -e '77d' -i CMake/modules/GetGitRevisionDescription.cmake
  '';

  preConfigure = ''
    export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:$(echo "${jamomacore}/jamoma/share/cmake/Jamoma")"
  '';

  preBuild = ''
    ninja
  '';

  installPhase = ''
    cmake --build . --target install
  '';

  meta = {
    description = "An interactive sequencer for the intermedia arts";
    homepage = http://i-score.org/;
    license = stdenv.lib.licenses.cecill20;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
