{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, glew
, glfw
, libtheora
, portaudio
, libogg
, zlib
, SDL2
, libXcursor
, libXrandr
, libXext
, libXScrnSaver
, libXi
, libXfixes
}:

stdenv.mkDerivation rec {
  pname = "RSDKv5";
  version = lib.strings.substring 0 7 src.rev;

  src = fetchFromGitHub {
    owner = "Rubberduckycooly";
    repo = "Sonic-Mania-Decompilation";
    rev = "8278952deec0e5acbe3a0d5bd3a7bac4c297e65a";
    fetchSubmodules = true;
    sha256 = "sha256-q8aQxgu3ssqqNtNLKL4DbbsuddeXk5HoY+G79ep5/Sk=";
  };

  sourceRoot = "${src.name}/dependencies/RSDKv5";

  postPatch = ''
    substituteInPlace makefiles/Linux.cfg \
      --replace-fail 'portaudio' 'portaudio-2.0'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glew glfw libtheora portaudio libogg zlib SDL2 libXcursor libXext libXScrnSaver libXrandr libXi libXfixes ];

  makeFlags = [ "AUTOBUILD=1" ];

  installPhase = ''
    mkdir -p $out/share $out/bin
    cp -r bin/Linux/OGL $out/share/rsdkv5
    ln -s $out/share/rsdkv5/RSDKv5U $out/bin/
  '';

  postFixup = ''
    patchelf --add-rpath $out/share/rsdkv5 $out/share/rsdkv5/RSDKv5U
  '';

  meta = {
    description = "Decompilation of Sonic Mania";
    homepage = "https://github.com/Rubberduckycooly/Sonic-Mania-Decompilation";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.linux;
    mainProgram = "RSDKv5U";
  };
}
