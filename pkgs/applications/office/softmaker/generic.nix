{ lib, stdenv, autoPatchelfHook, makeDesktopItem, makeWrapper, copyDesktopItems

  # Dynamic Libraries
, curl, libGL, libX11, libXext, libXmu, libXrandr, libXrender

  # For fixing up execution of /bin/ls, which is necessary for
  # product unlocking.
, coreutils, libredirect

  # Extra utilities used by the SoftMaker applications.
, gnugrep, util-linux, which

, pname, version, edition, suiteName, src, archive

, ...
}:

let
  desktopItems = import ./desktop_items.nix {
    inherit makeDesktopItem pname suiteName;
  };
  shortEdition = builtins.substring 2 2 edition;
in stdenv.mkDerivation {
  inherit pname src;

  version = "${edition}.${version}";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
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

  installPhase = let
    # SoftMaker/FreeOffice collects some system information upon
    # unlocking the product. But in doing so, it attempts to execute
    # /bin/ls. If the execve syscall fails, the whole unlock
    # procedure fails. This works around that by rewriting /bin/ls
    # to the proper path.
    #
    # In addition, it expects some common utilities (which, whereis)
    # to be in the path.
    #
    # SoftMaker Office restarts itself upon some operations, such
    # changing the theme and unlocking. Unfortunately, we do not
    # have control over its environment then and it will fail
    # with an error.
    extraWrapperArgs = ''
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS "/bin/ls=${coreutils}/bin/ls" \
      --prefix PATH : "${lib.makeBinPath [ coreutils gnugrep util-linux which ]}"
    '';
  in ''
    runHook preInstall

    mkdir -p $out/share
    cp -r ${pname} $out/share/${pname}${edition}

    # Wrap rather than symlinking, so that the programs can determine
    # their resource path.
    mkdir -p $out/bin
    makeWrapper $out/share/${pname}${edition}/planmaker $out/bin/${pname}-planmaker \
      ${extraWrapperArgs}
    makeWrapper $out/share/${pname}${edition}/presentations $out/bin/${pname}-presentations \
      ${extraWrapperArgs}
    makeWrapper $out/share/${pname}${edition}/textmaker $out/bin/${pname}-textmaker \
      ${extraWrapperArgs}

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

    # freeoffice 973 misses the 96x96 application icons, giving broken symbolic links
    # remove broken symbolic links
    find $out -xtype l -ls -exec rm {} \;

    # Add mime types
    install -D -t $out/share/mime/packages ${pname}/mime/softmaker-*office*${shortEdition}.xml

    runHook postInstall
  '';

  desktopItems = builtins.attrValues desktopItems;

  meta = with lib; {
    description = "An office suite with a word processor, spreadsheet and presentation program";
    homepage = "https://www.softmaker.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
