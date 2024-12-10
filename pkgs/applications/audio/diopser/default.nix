{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libjack2,
  alsa-lib,
  freetype,
  libX11,
  libXrandr,
  libXinerama,
  libXext,
  libXcursor,
}:

let

  # Derived from subprojects/function2.wrap
  function2 = rec {
    version = "4.1.0";
    src = fetchFromGitHub {
      owner = "Naios";
      repo = "function2";
      rev = version;
      hash = "sha256-JceZU8ZvtYhFheh8BjMvjjZty4hcYxHEK+IIo5X4eSk=";
    };
  };

  juce = rec {
    version = "unstable-2021-04-07";
    src = fetchFromGitHub {
      owner = "juce-framework";
      repo = "JUCE";
      rev = "1a5fb5992a1a4e28e998708ed8dce2cc864a30d7";
      sha256 = "1ri7w4sz3sy5xilibg53ls9526fx7jwbv8rc54ccrqfhxqyin308";
    };
  };

in
stdenv.mkDerivation rec {
  pname = "diopser";
  version = "unstable-2021-5-13";

  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = pname;
    fetchSubmodules = true;
    rev = "d5fdc92f1caf5a828e071dac99e106e58f06d84d";
    sha256 = "06y1h895yxh44gp4vxzrna59lf7nlfw7aacd3kk4l1g56jhy9pdx";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc-11-build.patch";
      url = "https://github.com/robbert-vdh/diopser/commit/a7284439bd4e23455132e7806a214f9db12efae9.patch";
      hash = "sha256-r3yxhnhPUQ47srhfAKeurpe2xyEBdSvqIbgqs9/6gD4=";
    })
  ];

  postUnpack = ''
    (
      cd "$sourceRoot"
      cp -R --no-preserve=mode,ownership ${function2.src} function2
      cp -R --no-preserve=mode,ownership ${juce.src} JUCE
      sed -i 's@CPMAddPackage("gh:juce-framework/JUCE.*@add_subdirectory(JUCE)@g' CMakeLists.txt
      sed -i 's@CPMAddPackage("gh:Naios/function2.*@add_subdirectory(function2)@g' CMakeLists.txt
      patchShebangs .
    )
  '';

  installPhase = ''
    mkdir -p $out/lib/vst3
    cp -r Diopser_artefacts/Release/VST3/Diopser.vst3 $out/lib/vst3
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libjack2
    alsa-lib
    freetype
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  meta = with lib; {
    description = "A totally original phase rotation plugin";
    homepage = "https://github.com/robbert-vdh/diopser";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.all;
  };
}
