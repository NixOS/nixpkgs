{ stdenv, fetchFromGitHub, fetchzip, unzip
, alsaLib, astyle, clang, freetype, gnumake, libjack2, xorg
}:

let
  vst2 = fetchzip {
    url = "https://archive.org/download/VST2SDK/vstsdk2_4.zip";
    sha256 = "10jm5rijh2sq2m60zlf9plvii0p1x6fgy4dalyg963q1kbwri8q3";
    name = "vst2";
  };
  vst3 = fetchzip {
    url = "https://github.com/steinbergmedia/vst3sdk/archive/vstsdk3612_03_12_2018_build_67.tar.gz";
    sha256 = "1pkrll0fb5mq9wrrsfcwxbqdhajp6zdya9pznmmn09pbqf009yky";
    name = "vst3";
  };
in stdenv.mkDerivation rec {
  pname = "squeezer";
  version = "v2.5.4";

  src = fetchFromGitHub {
    owner = "mzuther";
    repo = "Squeezer";
    rev = version;
    sha256 = "1l4dsbwcgimc6wpqpmvv4wmq45sfglcwbix0n65wmg36wdxvnxwl";
  };

  patchPhase = ''
    patchShebangs .
  '';

  buildPhase = ''
    # Prepping missing libraries

    cd libraries
    rm -r juce vst2 vst3
    mkdir vst2
    cp -r ${vst2} vst2/VST2_SDK
    cp -r ${vst3} vst3

    unzip juce_5.4.7.zip
    mv JUCE-5.4.7 juce

    # Let's build

    cd ../Builds
    make -j16 --directory=linux/gmake config=release_x64 all
  '';

  installPhase = ''
    # Prepping missing libraries

    cd ../bin

    ./finalise_binaries.sh

    cd final

    mkdir -p $out/bin
    mkdir -p $out/lib/vst

    mv *vst2_x64.so   $out/lib/vst/
    cp -a squeezer    $out/lib/vst/
    mv *_x64          $out/bin/
    cp -a squeezer    $out/bin/
  '';

  buildInputs = [
    alsaLib
    astyle
    clang
    freetype
    gnumake
    libjack2
    unzip
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrandr
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.mzuther.de/en/software/squeezer";
    description = "Flexible general-purpose audio compressor with a touch of citrus";
    maintainers = [ maintainers.jpotier ];
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}
