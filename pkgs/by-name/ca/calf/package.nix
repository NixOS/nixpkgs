{
  lib,
  stdenv,
  expat,
  fftwSinglePrec,
  fluidsynth,
  libjack2,
  ladspa-header,
  lv2,
  pkg-config,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "calf";
  version = "0.90.9";

  src = fetchFromGitHub {
    owner = "calf-studio-gear";
    repo = "calf";
    tag = finalAttrs.version;
    hash = "sha256-ypSoKUeJC8EUc0a5xIYQ/7/mSQKjWLqM4h/UrDRzujs=";
  };

  patches = [
    # https://github.com/calf-studio-gear/calf/pull/414
    ./cmake-4.5-compat.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt src/CMakeLists.txt \
      --replace-fail '"''${CMAKE_INSTALL_PREFIX}/''${CMAKE_INSTALL_LIBDIR}' '"''${CMAKE_INSTALL_FULL_LIBDIR}'
  '';

  outputs = [
    "out"
    "doc"
  ];

  enableParallelBuilding = true;

  cmakeFlags = [ (lib.cmakeBool "WANT_GUI" false) ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    expat
    fftwSinglePrec
    fluidsynth
    libjack2
    ladspa-header
    lv2
  ];

  meta = {
    homepage = "https://calf-studio-gear.org";
    changelog = "https://github.com/calf-studio-gear/calf/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Set of high quality open source audio plugins for musicians";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "calfjackhost";
  };
})
