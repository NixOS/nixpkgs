{ stdenv, lib, fetchFromGitHub, pkgconfig, curl, libzip, jansson, openssl,
  mesa_glu, vulkan-loader, glew, glfw, gtk2, xorg,
  alsaLib, rtaudio, rtmidi, speexdsp }:

plugins:

stdenv.mkDerivation rec {
  name = "Rack-${version}";
  version = "53fdea1cd15415f60a3c1dc8d8e4340bd06e65e6";

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    rev = "${version}";
    sha256 = "0zac3y4x7iypidxp8x7m0ia4ky9h6gdxq3lwm61s69xygnr92w1r";
    fetchSubmodules = true;
  };

  prePatch = ''
    sed -i "1,51s|dir = \".\"|dir = \"$out\"|g" src/asset.cpp
  '';
  patches = [ ./makefile.diff ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    curl libzip jansson openssl
    mesa_glu vulkan-loader glew glfw gtk2
    xorg.libX11 xorg.libXrandr xorg.libXinerama xorg.libXcursor xorg.libXi xorg.libXext
    alsaLib rtaudio rtmidi speexdsp
  ];

  preBuild = ''
    LIBS="libcurl libzip glew glfw3 jansson gtk+-2.0 rtaudio rtmidi speexdsp openssl"
    makeFlagsArray=(LIBS=$LIBS);

    pushd dep
    mkdir -p include
    make include/nanovg.h
    make include/nanosvg.h
    make include/blendish.h
    make include/osdialog.h
    popd
  ''
  +
  lib.concatStrings (lib.mapAttrsToList(name: plugin: ''
    mkdir -p plugins/${name}
    cp -r ${plugin}/* plugins/${name}
  '') plugins);

  postBuild = lib.concatStrings (lib.mapAttrsToList (name: plugin: ''
    pushd plugins/${name}/
    make LIBS="$LIBS"
    popd
  '') plugins);

  installPhase = ''
    install -D -t $out/bin/ Rack
    cp -r res $out/
    cp -r plugins $out/
  '';

  meta = {
    description = "Rack is the engine for the VCV open-source virtual modular synthesizer.";
    homepage =  https://vcvrack.com/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.skeidel ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
