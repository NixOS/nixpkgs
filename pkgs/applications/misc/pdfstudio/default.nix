{ stdenv,
  lib,
  makeWrapper,
  fetchurl,
  dpkg,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  gst_all_1,
  sane-backends,
  xorg,
  gnome2,
  alsa-lib,
  libgccjit,
  }:

let
  year = "2021";
  rel = "1";
  subrel = "1";
in
stdenv.mkDerivation rec {
  pname = "pdfstudio";
  version = "${year}.${rel}.${subrel}";
  autoPatchelfIgnoreMissingDeps=true;

  src = fetchurl {
    url = "https://download.qoppa.com/${pname}/v${year}/PDFStudio_v${year}_${rel}_${subrel}_linux64.deb";
    sha256 = "089jfpbsxwjhx245g8svlmg213kny3z5nl6ra1flishnrsfjjcxb";
  };

  nativeBuildInputs = [
    gst_all_1.gst-libav
    sane-backends
    xorg.libXxf86vm
    xorg.libXtst
    gnome2.libgtkhtml
    alsa-lib
    libgccjit
    autoPatchelfHook
    makeWrapper
    dpkg
    copyDesktopItems
  ];

  desktopItems = lib.singleton (makeDesktopItem {
       name = "${pname}${year}";
       desktopName = "PDF Studio";
       genericName = "View and edit PDF files";
       exec = "${pname} %f";
       icon = "${pname}${year}";
       comment = "Views and edits PDF files";
       mimeType = "application/pdf";
       categories = "Office";
       type = "Application";
       terminal = false;
  });

  unpackPhase = "dpkg-deb -x $src .";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp -r opt/${pname}${year} $out/share/
    ln -s $out/share/${pname}${year}/.install4j/${pname}${year}.png  $out/share/pixmaps/
    makeWrapper $out/share/${pname}${year}/${pname}${year} $out/bin/${pname}

    runHook postInstall
  '';

  # We need to run pdfstudio once. This will unpack some jre.pack files in jre/lib.
  # We must do this after autoPatchelfHook, so we'll do this in preInstallCheck.
  # An alternative would beo to patchelf manually, using this (e.g., in the fixup phase):
  # find $out/share/${pname}${year}/jre/bin -type f -executable -exec patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) {} \;
  doInstallCheck = true;
  preInstallCheck = ''
    $out/share/${pname}${year}/${pname}${year}
  '';

  meta = with lib; {
    homepage = "https://www.qoppa.com/pdfstudio/";
    description = "An easy to use, full-featured PDF editing software";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.pwoelfel ];
  };
}
