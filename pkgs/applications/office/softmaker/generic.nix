{ stdenv, fetchurl, autoPatchelfHook, makeDesktopItem, makeWrapper

  # Dynamic Libraries
, curl, libGL, libX11, libXext, libXmu, libXrandr, libXrender

, pname, version, edition, suiteName, src, archive

, ...
}:

let
  desktopItems = import ./desktop_items.nix {
    inherit makeDesktopItem pname suiteName;
  };
  shortEdition = builtins.substring 2 2 edition;
in stdenv.mkDerivation rec {
  inherit pname version edition shortEdition src;
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    curl
    libGL
    libX11
    libXext
    libXmu
    libXrandr
    libXrender
    stdenv.cc.cc.lib
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack

    mkdir installer
    tar -C installer -xf ${src}
    mkdir ${pname}
    tar -C ${pname} -xf installer/${archive}

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r ${pname} $out/share/${pname}${edition}

    # Wrap rather than symlinking, so that the programs can determine
    # their resource path.
    mkdir -p $out/bin
    makeWrapper $out/share/${pname}${edition}/planmaker $out/bin/${pname}-planmaker
    makeWrapper $out/share/${pname}${edition}/presentations $out/bin/${pname}-presentations
    makeWrapper $out/share/${pname}${edition}/textmaker $out/bin/${pname}-textmaker

    for size in 16 32 48 64 96 128 256 512 1024; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps

      for app in pml prl tml; do
        ln -s $out/share/${pname}${edition}/icons/''${app}_''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}-''${app}.png
      done

      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/mimetypes

      for mimetype in pmd prd tmd; do
        ln -s $out/share/${pname}${edition}/icons/''${mimetype}_''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/mimetypes/application-x-''${mimetype}.png
      done
    done

    # Add desktop items
    ${desktopItems.planmaker.buildCommand}
    ${desktopItems.presentations.buildCommand}
    ${desktopItems.textmaker.buildCommand}

    # Add mime types
    install -D -t $out/share/mime/packages ${pname}/mime/softmaker-*office*${shortEdition}.xml

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "An office suite with a word processor, spreadsheet and presentation program";
    homepage = "https://www.softmaker.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ danieldk ];
    platforms = [ "x86_64-linux" ];
  };
}
