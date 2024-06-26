{ lib, stdenv, fetchurl, makeWrapper, unzip, autoPatchelfHook, makeDesktopItem, copyDesktopItems
, gtk2, glib, gdk-pixbuf, pango, cairo, atk
, freetype, fontconfig, xorg, zlib
}:

let
  pkgDescription = "A application to display NIfTI medical imaging data.";
in

stdenv.mkDerivation rec {
  pname = "mricron";
  version = "1.0.20190902";

  src = fetchurl {
    url = "https://github.com/neurolabusc/MRIcron/releases/download/v${version}/MRIcron_linux.zip";
    sha256 = "sha256-C155u9dvYEyWRfTv3KNQFI6aMWIAjgvdSIqMuYVIOQA=";
  };

  nativeBuildInputs = [ makeWrapper unzip autoPatchelfHook copyDesktopItems ];
  buildInputs = [ gtk2 glib gdk-pixbuf pango cairo atk freetype fontconfig xorg.libX11 zlib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/${pname}
    mkdir -p $out/share/icons/hicolor/256x256/apps

    install -Dm555 ./MRIcron $out/bin/${pname}
    install -Dm444 -t $out/share/icons/hicolor/scalable/apps/ ./Resources/mricron.svg
    cp -r ./Resources/* $out/share/${pname}/

    runHook autoPatchelfHook $out/bin/${pname}
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "mricron";
      desktopName = "MRIcron";
      comment = pkgDescription;
      exec = "mricron %U";
      icon = "${pname}";
      categories = [ "Graphics" "MedicalSoftware" "Science" ];
      terminal = false;
      keywords = [ "medical" "imaging" "nifti" ];
    })
  ];

  outputsToInstall = [ "out" "desktopItem" ];

  meta = with lib; {
    description = pkgDescription;
    homepage = "http://people.cas.sc.edu/rorden/mricron/index.html";
    license = licenses.bsd1;
    platforms = platforms.linux;
    maintainers = with maintainers; [ adriangl ];
    mainProgram = "mricron";
  };
}
