{ stdenv, fetchFromGitHub, pkg-config, alsaLib, curl, freetype, zenity
, gtk3, webkitgtk, udev, boost, libbfd, makeDesktopItem, which, libX11
, libXext, libXinerama }:

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
  version = "6.0.36";

  src = fetchFromGitHub {
    owner = "RomanKubiak";
    repo = "ctrlr";
    # Scripts/git-revision.sh
    rev = "2f9ce2ea74e49cb324442eae530b74aff59c35f2";
    sha256 = "1hj15qms1dpi9v0qslsdqxq0kh659wh8ggzj9wym3mmw5nhxlwhq";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config boost ];
  buildInputs = [
    alsaLib curl freetype libX11 libXext libXinerama gtk3 webkitgtk
    udev libbfd
  ];

  NIX_CFLAGS_COMPILE = [ "-DPACKAGE_VERSION" ];

  postPatch = ''
    substituteInPlace JUCE/modules/juce_gui_basics/native/juce_linux_FileChooser.cpp \
      --replace '"which' '"${which}/bin/which' \
      --replace '"zenity' '"${zenity}/bin/zenity'
  '';

  preBuild = ''
    cd Builds/LinuxMakefile
  '';

  installPhase = ''
    install -D -m755 build/Ctrlr $out/bin/Ctrlr
    install -D -m755 build/Ctrlr.so $out/lib/vst/Ctrlr.so
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
