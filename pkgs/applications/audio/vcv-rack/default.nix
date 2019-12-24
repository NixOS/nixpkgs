{ stdenv, makeWrapper, fetchFromBitbucket, fetchFromGitHub, pkgconfig
, alsaLib, curl, glew, glfw, gtk2-x11, jansson, libjack2, libXext, libXi
, libzip, rtaudio, rtmidi, speex }:

let
  glfw-git = glfw.overrideAttrs (oldAttrs: rec {
    name = "glfw-git-${version}";
    version = "2019-06-30";
    src = fetchFromGitHub {
      owner = "glfw";
      repo = "glfw";
      rev = "d25248343e248337284dfbe5ecd1eddbd37ae66d";
      sha256 = "0gbz353bfmqbpm0af2nqf5draz3k4f3lqwiqj68s8nwn7878aqm3";
    };
    buildInputs = oldAttrs.buildInputs ++ [ libXext libXi ];
  });
  pfft-source = fetchFromBitbucket {
    owner = "jpommier";
    repo = "pffft";
    rev = "29e4f76ac53bef048938754f32231d7836401f79";
    sha256 = "084csgqa6f1a270bhybjayrh3mpyi2jimc87qkdgsqcp8ycsx1l1";
  };
  nanovg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanovg";
    rev = "1f9c8864fc556a1be4d4bf1d6bfe20cde25734b4";
    sha256 = "08r15zrr6p1kxigxzxrg5rgya7wwbdx7d078r362qbkmws83wk27";
  };
  nanosvg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "25241c5a8f8451d41ab1b02ab2d865b01600d949";
    sha256 = "114qgfmazsdl53rm4pgqif3gv8msdmfwi91lyc2jfadgzfd83xkg";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "e5db5de6444f4b2c4e1390c67b3efd718080c3da";
    sha256 = "0iqxn1md053nl19hbjk8rqsdcmjwa5l5z0ci4fara77q43rc323i";
  };
  oui-blendish-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "oui-blendish";
    rev = "79ec59e6bc7201017fc13a20c6e33380adca1660";
    sha256 = "17kd0lh2x3x12bxkyhq6z8sg6vxln8m9qirf0basvcsmylr6rb64";
  };
in
with stdenv.lib; stdenv.mkDerivation rec {
  pname = "VCV-Rack";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    rev = "v${version}";
    sha256 = "1wm41jkdm3dacl1n7q65lp3a4a5n2pz1wgb559hingfa2h0cwvsw";
  };

  patches = [
    ./rack-minimize-vendoring.patch
    # We patch out a call to a custom function, that is not needed on Linux.
    # This avoids needing a patched version of glfw. The version we previously used disappeared
    # on GitHub. See https://github.com/NixOS/nixpkgs/issues/71189
    ./remove-custom-glfw-function.patch
  ];

  prePatch = ''
    mkdir -p dep/include

    cp -r ${pfft-source} dep/jpommier-pffft-source
    cp -r ${nanovg-source}/* dep/nanovg
    cp -r ${nanosvg-source}/* dep/nanosvg
    cp -r ${osdialog-source}/* dep/osdialog
    cp -r ${oui-blendish-source}/* dep/oui-blendish

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
  buildInputs = [ glfw-git alsaLib curl glew gtk2-x11 jansson libjack2 libzip rtaudio rtmidi speex ];

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
