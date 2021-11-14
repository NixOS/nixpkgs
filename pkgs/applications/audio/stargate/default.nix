{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, substituteAll
, alsa-lib
, autoconf
, automake
, ffmpegSupport ? true
, ffmpeg
, fftw
, fftwSinglePrec
, file
, gdb
, gettext
, jq
, lameSupport ? true
, lame
, libsbsms
, libsndfile
, pkg-config
, portaudio
, portmidi
, python3
, python3Packages
, rubberband
, stargate-libcds
, vorbisToolsSupport ? true
, vorbis-tools
, wrapQtAppsHook
}:

let
  python3CommonInputs = python3.withPackages
    (ps: with ps; [
      jinja2
      mido
      mutagen
      numpy
      psutil
      pymarshal
      pyqt5
      pyyaml
      wavefile
      wheel
    ]);
in
stdenv.mkDerivation rec {
  pname = "stargate";
  version = "21.11.6";

  src = fetchFromGitHub {
    owner = "stargateaudio";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-opAJmxdibQe/mzCi7no+VNI5uSG0Jk5GILQbHvVOAIM=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gdb
    jq
    pkg-config
    python3Packages.cython
    python3Packages.setuptools
    wrapQtAppsHook
  ];

  buildInputs = [
    fftw
    fftwSinglePrec
    gettext
    libsbsms
    libsndfile
    portaudio
    portmidi
    python3
    rubberband
    stargate-libcds
    file
  ]
  ++ lib.optional stdenv.isLinux alsa-lib
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optional lameSupport lame
  ++ lib.optional vorbisToolsSupport vorbis-tools;

  propagatedBuildInputs = [
    python3CommonInputs
  ];

  checkInputs = with python3Packages; [
    python3CommonInputs
    pytest
    yq
  ];

  patches = [
    # Remove vendored python dependencies.
    # Remove unecessary tests (coverage, valgrind).
    # Use flags according to platform.
    (substituteAll {
      src = ./build_test.patch;
      platflags = with stdenv;
        if isLinux then "-mfpmath=sse -mssse3 -mtune=generic -mstackrealign"
        else if (isAarch32 || isAarch64) then "-march=native"
        else "";
    })

    # Patch paths of shared libraries and binaries.
    (substituteAll {
      src = ./path.patch;
      libportaudio = "${lib.getLib portaudio}/lib/libportaudio${stdenv.hostPlatform.extensions.sharedLibrary}";
      libportmidi = "${lib.getLib portmidi}/lib/libportmidi${stdenv.hostPlatform.extensions.sharedLibrary}";
      file = "${file}/bin/file";
    })

    # Backport fix to find sbsms binary
    # https://github.com/stargateaudio/stargate/pull/24
    ./sglib-lib-util.py.patch
  ];

  preConfigure = ''
    cd src
  '';

  SRC_SG_PY_VENDOR_DIR = "sg_py_vendor";

  doCheck = true;

  preCheck = ''
    # Fix Permission denied: /homeless-shelter
    # https://github.com/NixOS/nixpkgs/issues/12591
    mkdir -p check-phase
    export HOME=$PWD/check-phase

    rm -rf ${SRC_SG_PY_VENDOR_DIR}/pymarshal ${SRC_SG_PY_VENDOR_DIR}/wavefile

    mkdir -p ${SRC_SG_PY_VENDOR_DIR}

    ln -s ${python3Packages.pymarshal} ${SRC_SG_PY_VENDOR_DIR}/pymarshal
    ln -s ${python3Packages.wavefile} ${SRC_SG_PY_VENDOR_DIR}/wavefile
  '';

  checkTarget = [ "tests" ];

  installFlags = [ "PREFIX=$(out)/usr" ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/usr/bin/stargate" \
      --set PYTHONPATH "$PYTHONPATH:${python3.pkgs.pyqt5}/lib/python3.9/site-packages/PyQt5"
  '';

  meta = {
    description = "Digital audio workstation, instrument and effect plugins, wave editor";
    longDescription = ''
      Stargate is a holistic audio production solution,
      everything you need to make music on a computer.
    '';
    homepage = "https://stargateaudio.github.io";
    changelog = "https://github.com/stargateaudio/stargate/releases";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ yuu ];
  };
}
