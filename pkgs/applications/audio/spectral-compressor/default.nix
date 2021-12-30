{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, libjack2, alsa-lib, freetype, libX11, libXrandr, libXinerama, libXext, libXcursor, fftwFloat
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
      sha256= "1ri7w4sz3sy5xilibg53ls9526fx7jwbv8rc54ccrqfhxqyin308";
    };
  };


in  stdenv.mkDerivation rec {
  pname = "spectral-compressor";
  version = "unstable-2021-12-30";

  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = pname;
    fetchSubmodules = true;
    rev = "97bf23bef83a76057d808971627ce2e7f4859f2f";
    sha256 = "sha256-YbcIWcyePbYA/3b4l69q3juJLj/H6Uxoi/Ew/4Q0xJA=";
  };

  postUnpack = ''
  (
  cd "$sourceRoot"
  cp -R --no-preserve=mode,ownership ${juce.src} JUCE
  cp -R --no-preserve=mode,ownership ${function2.src} function2
  sed -i 's@CPMAddPackage("gh:juce-framework/JUCE.*@add_subdirectory(JUCE)@g' CMakeLists.txt
  sed -i 's@CPMAddPackage("gh:Naios/function2.*@add_subdirectory(function2)@g' CMakeLists.txt
  patchShebangs .
  )
  '';

  installPhase = ''
    mkdir -p $out/lib/vst3
    cp -r SpectralCompressor_artefacts/Release/VST3/Spectral\ Compressor.vst3 $out/lib/vst3
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libjack2 alsa-lib freetype libX11 libXrandr libXinerama libXext
    libXcursor fftwFloat
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  meta = with lib; {
    description = "Everything can be pink noise if you try hard enough!";
    homepage = "https://github.com/robbert-vdh/spectral-compressor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.all;
  };
}
