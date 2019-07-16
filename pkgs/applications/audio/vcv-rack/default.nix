{ stdenv, makeWrapper, fetchFromBitbucket, fetchFromGitHub, pkgconfig
, alsaLib, curl, glew, glfw, gtk2-x11, jansson, libjack2, libXext, libXi
, libzip, rtaudio, rtmidi, speex }:

let
  glfw-git = glfw.overrideAttrs (oldAttrs: rec {
    name = "glfw-git-${version}";
    version = "unstable-2018-05-29";
    src = fetchFromGitHub {
      owner = "glfw";
      repo = "glfw";
      rev = "0be4f3f75aebd9d24583ee86590a38e741db0904";
      sha256 = "0zbcjgc7ks25yi949k0wjknfl00a4dqmz45mhp00k62vlq2sj0i5";
    };
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
  name = "VCV-Rack-${version}";
  version = "0.6.2b";

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    rev = "v${version}";
    sha256 = "17ynhxcci6dyn1yi871fd8yli4924fh12pmk510djwkcj5crhas6";
    fetchSubmodules = true;
  };

  prePatch = ''
    ln -s ${pfft-source} dep/jpommier-pffft-source

    mkdir -p dep/include

    cp dep/jpommier-pffft-source/*.h dep/include
    cp dep/nanosvg/src/*.h dep/include
    cp dep/nanovg/src/*.h dep/include
    cp dep/osdialog/*.h dep/include
    cp dep/oui-blendish/*.h dep/include

    substituteInPlace include/audio.hpp --replace "<RtAudio.h>" "<rtaudio/RtAudio.h>"
    substituteInPlace compile.mk --replace "-march=nocona" ""
    substituteInPlace Makefile \
       --replace "-Wl,-Bstatic" "" \
       --replace "-lglfw3" "-lglfw"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ glfw-git alsaLib curl glew gtk2-x11 jansson libjack2 libzip rtaudio rtmidi speex ];

  buildFlags = "Rack";

  installPhase = ''
    install -D -m755 -t $out/bin Rack
    cp -r res $out/

    mkdir -p $out/share/rack
    cp LICENSE.txt LICENSE-dist.txt $out/share/rack

    # Override the default global resource file directory
    wrapProgram $out/bin/Rack --add-flags "-g $out"
  '';

  meta = with stdenv.lib; {
    description = "Open-source virtual modular synthesizer";
    homepage = http://vcvrack.com/;
    # The source is BSD-3 licensed, some of the art is CC-BY-NC 4.0 or under a
    # no-derivatives clause
    license = with licenses; [ bsd3 cc-by-nc-40 unfreeRedistributable ];
    maintainers = with maintainers; [ moredread ];
    platforms = platforms.linux;
  };
}
