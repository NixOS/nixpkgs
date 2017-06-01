{
  boost,
  cln,
  cmake,
  fetchgit,
  gcc,
  ginac,
  jamomacore,
  kdnssd,
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
    sha256 = "0cl9vdmxkshdacgpp7s2rg40b7xbsjrzw916jds9i3rpq1pcy5pj";
    leaveDotGit = true;
    deepClone = true;
  };

  buildInputs = [
    boost
    cln
    cmake
    ginac
    gcc
    jamomacore
    kdnssd
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
