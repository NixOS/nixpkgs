{ stdenv, makeWrapper, fetchFromBitbucket, fetchFromGitHub, pkgconfig
, alsaLib, curl, glew, glfw, gtk2-x11, jansson, libjack2, libXext, libXi
, libzip, rtaudio, rtmidi, speex, libsamplerate }:

let
  glfw-git = glfw.overrideAttrs (oldAttrs: rec {
    name = "glfw-git-${version}";
    version = "2019-06-30";
    src = fetchFromGitHub {
      owner = "AndrewBelt";
      repo = "glfw";
      rev = "d9ab59efc781c392128a449361a381fcc93cf6f3";
      sha256 = "1ykkq6qq8y6j5hlfj2zp1p87kr33vwhywziprz20v5avx1q7rjm8";
    };
    # We patch the source to export a function that was added to the glfw fork
    # for Rack so it is present when we build glfw as a shared library.
    # See https://github.com/AndrewBelt/glfw/pull/1 for discussion of this issue
    # with upstream.
    patches = [ ./glfw.patch ];
    buildInputs = oldAttrs.buildInputs ++ [ libXext libXi ];
  });
  pfft-source = fetchFromBitbucket {
    owner = "jpommier";
    repo = "pffft";
    rev = "29e4f76ac53bef048938754f32231d7836401f79";
    sha256 = "084csgqa6f1a270bhybjayrh3mpyi2jimc87qkdgsqcp8ycsx1l1";
  };
in
with stdenv.lib; stdenv.mkDerivation rec {
  pname = "VCV-Rack";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    rev = "v${version}";
    sha256 = "172v66v2vb6l9dpsq6fb6xn035igwhpjci8w3kz2na3rvmz1bc5w";
    fetchSubmodules = true;
  };

  patches = [ ./rack-minimize-vendoring.patch ];

  prePatch = ''
    cp -r ${pfft-source} dep/jpommier-pffft-source

    mkdir -p dep/include

    cp dep/jpommier-pffft-source/*.h dep/include
    cp dep/nanosvg/**/*.h dep/include
    cp dep/nanovg/src/*.h dep/include
    cp dep/osdialog/*.h dep/include
    cp dep/oui-blendish/*.h dep/include

    substituteInPlace include/audio.hpp --replace "<RtAudio.h>" "<rtaudio/RtAudio.h>"
    substituteInPlace compile.mk --replace "-march=nocona" ""
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ glfw-git alsaLib curl glew gtk2-x11 jansson libjack2 libzip rtaudio rtmidi speex libsamplerate ];

  buildFlags = "Rack";

  installPhase = ''
    install -D -m755 -t $out/bin Rack

    mkdir -p $out/share/vcv-rack
    cp -r res Core.json template.vcv LICENSE* cacert.pem $out/share/vcv-rack

    # Override the default global resource file directory
    wrapProgram $out/bin/Rack --add-flags "-s $out/share/vcv-rack"
  '';

  meta = with stdenv.lib; {
    description = "Open-source virtual modular synthesizer";
    homepage = http://vcvrack.com/;
    # The source is BSD-3 licensed, some of the art is CC-BY-NC 4.0 or under a
    # no-derivatives clause
    license = with licenses; [ bsd3 cc-by-nc-40 unfreeRedistributable ];
    maintainers = with maintainers; [ moredread nathyong ];
    platforms = platforms.linux;
  };
}
