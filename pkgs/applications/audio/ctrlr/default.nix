{ stdenv, fetchFromGitHub, pkgconfig, alsaLib, curl, freetype, xorg
, gtk3, webkitgtk, udev, boost, libbfd, gnome3, makeDesktopItem, lib
, which }:

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
  # Source/Core/CtrlrRevision.h
  version = "6.0.35";

  src = fetchFromGitHub {
    owner = "RomanKubiak";
    repo = "ctrlr";
    rev = "8127356e910cd29cc09e19a3a423f2d25dc382f1";
    sha256 = "0by49k8yn7f8b4v320bwf0qgczmxvzwvn0wsf17v9xmhkdw9vc5n";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  patches = lib.optionals (lib.versionAtLeast version "6.0")[
    ./patch-libr.h
  ] ++ lib.optionals ((lib.versionOlder libbfd.version "2.34") && (lib.versionAtLeast version "6.0.35")) [
    ./patch-libr-bfd.c
  ];
  patchFlags = [ "-p1" "--binary" ];

  makeFlags = [ "CFLAGS=-I$(src)/JUCE/modules" ];

  buildInputs = [ alsaLib curl freetype xorg.libX11 xorg.libXext
    xorg.libXinerama gtk3 webkitgtk udev boost libbfd ];
  nativeBuildInputs = [ pkgconfig ];

  preBuild = ''
    substituteInPlace JUCE/modules/juce_gui_basics/native/juce_linux_FileChooser.cpp \
      --replace '"which' '"${which}/bin/which' \
      --replace '"zenity' '"${gnome3.zenity}/bin/zenity'
    cd Builds/LinuxMakefile
  '';

  installPhase = ''
    install -D -m755 build/Ctrlr $out/bin/Ctrlr
    install -D -m755 build/Ctrlr.so $out/lib/vst/Ctrlr.so
    install -D ${desktopItem}/share/applications/Ctrlr.desktop \
      $out/share/applications/Ctrlr.desktop
  '';
}
