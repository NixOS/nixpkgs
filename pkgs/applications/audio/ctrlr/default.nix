{ stdenv, fetchFromGitHub, libGL, unzip, libX11, libbfd, zlib, udev, alsaLib, freetype
, libXrandr, libXinerama, libXext, libXcomposite, libXcursor, libiberty, zenity, which
, makeDesktopItem }:

let
  desktopItem = makeDesktopItem rec {
    name = "Ctrlr";
    exec = name;
    desktopName = name;
    genericName = "Ctrlr MIDI panel";
    categories = "Audio;AudioVideo;";
  };
in stdenv.mkDerivation rec {
  pname = "ctrlr";
  version = "5.3.201";

  src = fetchFromGitHub {
    owner = "RomanKubiak";
    repo = "ctrlr";
    # Scripts/git-revision.sh
    rev = "179e457a5280566df65645b49bebf6b424c3f4ca";
    sha256 = "0n4s896m2zpbhj13iz77nv2686shwgrwbsdk36f3v84gqz44925s";
  };

  patches = [
    # doesn't build with flac support
    ./patch-LAudio.cpp
  ];

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    libGL libX11 libbfd zlib udev alsaLib freetype libXrandr libXinerama libXext
    libXcomposite libXcursor libiberty
  ];

  NIX_CFLAGS_COMPILE = [
    "-DPACKAGE_VERSION"
    "-DJUCE_USE_FLAC=0"
    "-I../../../../Source/Misc/include/lo"
  ];

  makeFlags = [
    "CONFIG=Release"
  ];

  postUnpack = ''
    pushd source/Boost
    unzip -q boost.zip
    popd
  '';

  postPatch = ''
    substitute Source/Core/CtrlrRevision.template ./Source/Core/CtrlrRevision.h \
      --replace "%REVISION%" "${version}" \
      --replace "%REVISION_DATE%" ""
    substituteInPlace Builds/Generated/Linux/Standalone/Makefile \
      --replace "libbfd-\$(ARCH).a" "-lbfd" --replace "libiberty-\$(ARCH).a" "-liberty"
    substituteInPlace Juce/modules/juce_gui_basics/native/juce_linux_FileChooser.cpp \
      --replace '"which' '"${which}/bin/which' \
      --replace '"zenity' '"${zenity}/bin/zenity'
  '';

  buildPhase = ''
    pushd Builds/Generated/Linux/Standalone
    make -j$NIX_BUILD_CORES $makeFlags
    popd
    pushd Builds/Generated/Linux/VST
    make -j$NIX_BUILD_CORES $makeFlags
    popd
  '';

  installPhase = ''
    install -D -m755 Bin/Ctrlr $out/bin/Ctrlr
    install -D -m755 Bin/libCtrlr-VST-.so $out/lib/vst/Ctrlr.so
    install -D ${desktopItem}/share/applications/Ctrlr.desktop \
      $out/share/applications/Ctrlr.desktop
  '';

  meta = with stdenv.lib; {
    description = "MIDI editor for all your hardware";
    homepage = "https://ctrlr.org/";
    license = with licenses; [ gpl2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
