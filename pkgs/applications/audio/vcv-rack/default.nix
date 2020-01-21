{ stdenv, makeWrapper, fetchFromBitbucket, fetchFromGitHub, pkgconfig
, alsaLib, curl, glew, glfw, gtk2-x11, jansson, libjack2, libXext, libXi
, libzip, rtaudio, rtmidi, speex, libsamplerate }:

let
  # The package repo vendors some of the package dependencies as submodules.
  # Others are downloaded with `make deps`. Due to previous issues with the
  # `glfw` submodule (see above) and because we can not access the network when
  # building in a sandbox, we fetch the dependency source manually.
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
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    rev = "v${version}";
    sha256 = "0ji64prr74qzxf5bx1sw022kbslx9nzll16lmk5in78hbl137b3i";
  };

  patches = [
    ./rack-minimize-vendoring.patch
  ];

  prePatch = ''
    # As we can't use `make dep` to set up the dependencies (as explained
    # above), we do it here manually
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
  buildInputs = [ alsaLib curl glew glfw gtk2-x11 jansson libjack2 libsamplerate libzip rtaudio rtmidi speex ];

  buildFlags = [ "Rack" ];

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
