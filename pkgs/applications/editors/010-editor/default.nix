{ lib, stdenv, fetchFromGitHub, fetchurl, makeDesktopItem, autoPatchelfHook, copyDesktopItems, perlPackages, zlib, fontconfig, freetype, libxkbcommon, cups, ... }:

let
  extract = fetchFromGitHub {
    owner = "lod";
    repo = "unpack-install-jammer";
    rev = "41faa5a8c7925db4ff7ca665cca478979d177de4";
    sha256 = "1gvx7nkg4spz245hnmzcshiy0k3qvslqlzp4if7ngdqi2pfjrn4q";
  };
in
stdenv.mkDerivation rec {
  pname = "010-editor";
  version = "12.0.1";

  src = fetchurl {
    url = "https://download.sweetscape.com/010EditorLinux64Installer${version}.tar.gz";
    sha256 = "0ln8qxy1mij8qnnn8dxwnvmkx69l0f0w6xnb615ihx8wyhvlmfzh";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ] ++ (with perlPackages; [
    perl
    ModernPerl
    CompressRawLzma
    CompressRawZlib
    FileHomeDir
    TermProgressBar
    DataDump
  ]);

  buildInputs = [
    zlib
    freetype
    fontconfig
    libxkbcommon
    cups
  ];

  # Archive does not have a subdirectory
  setSourceRoot = "sourceRoot=$PWD";

  # Use shipped Qt5 libs
  runtimeDependencies = [ "$out" ];

  postUnpack = ''
    perl ${extract}/extract.pl -s Home=/ 010EditorLinux64Installer
  '';

  installPhase = ''
    runHook preInstall

    cp -ra install_dir/010editor $out

    mkdir $out/bin
    ln -s ../010editor $out/bin/010editor

    mkdir -p $out/share/pixmaps
    mv $out/010_icon_128x128.png $out/share/pixmaps/010-editor.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "010 Editor";
      comment = meta.description;
      exec = "010editor";
      icon = pname;
      categories = "Utility;Development";
    })
  ];

  meta = with lib; {
    description = "Professional text editor and hex editor";
    homepage = "https://www.sweetscape.com/010editor/";
    maintainers = with maintainers; [ ius ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
