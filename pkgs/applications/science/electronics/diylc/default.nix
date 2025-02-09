{ lib, stdenv, fetchurl, makeDesktopItem, unzip, bash, jre8 }:

let
  pname = "diylc";
  version = "4.18.0";
  files = {
    app = fetchurl {
      url = "https://github.com/bancika/diy-layout-creator/releases/download/v${version}/diylc-${version}.zip";
      sha256 = "09fpp3dn086clgnjz5yj4fh5bnjvj6mvxkx9n3zamcwszjmxr40d";
    };
    icon16 = fetchurl {
      url = "https://raw.githubusercontent.com/bancika/diy-layout-creator/v${version}/diylc/diylc-core/src/org/diylc/core/images/icon_small.png";
      sha256 = "1is50aidfwzwfzwqv57s2hwhx0r5c21cp77bkl93xkdqkh2wd8x4";
    };
    icon32 = fetchurl {
      url = "https://raw.githubusercontent.com/bancika/diy-layout-creator/v${version}/diylc/diylc-core/src/org/diylc/core/images/icon_medium.png";
      sha256 = "0a45p18n84xz1nd3zv3y16jlimvqzhbzg3q3f4lawgx4rcrn2n3d";
    };
    icon48 = fetchurl {
      url = "https://raw.githubusercontent.com/bancika/diy-layout-creator/v${version}/diylc/diylc-core/src/org/diylc/core/images/icon_large.png";
      sha256 = "06dkz0dcy8hfmnzr5ri5n1sh8r7mg83kzbvs3zy58wwhgzs1ddk6";
    };
  };
  launcher = makeDesktopItem {
    name = "diylc";
    desktopName = "DIY Layout Creator";
    comment = "Multi platform circuit layout and schematic drawing tool";
    exec = "diylc";
    icon = "diylc_icon";
    categories = [ "Development" "Electronics" ];
  };
in
stdenv.mkDerivation rec {
  inherit pname version;

  dontUnpack = true;

  buildInputs = [ jre8 ];
  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/diylc
    unzip -UU ${files.app} -d $out/share/diylc
    rm $out/share/diylc/diylc.exe
    rm $out/share/diylc/run.sh

    # Nope, the icon cannot be named 'diylc' because KDE does not like it.
    install -Dm644 ${files.icon16} $out/share/icons/hicolor/16x16/apps/diylc_icon.png
    install -Dm644 ${files.icon32} $out/share/icons/hicolor/32x32/apps/diylc_icon.png
    install -Dm644 ${files.icon48} $out/share/icons/hicolor/48x48/apps/diylc_icon.png

    mkdir -p $out/share/applications
    ln -s ${launcher}/share/applications/* $out/share/applications/

    mkdir -p $out/bin
    cat <<EOF > $out/bin/diylc
    #!${bash}/bin/sh
    cd $out/share/diylc
    ${jre8}/bin/java -Xms512m -Xmx2048m -Dorg.diylc.scriptRun=true -Dfile.encoding=UTF-8 -cp diylc.jar:lib org.diylc.DIYLCStarter
    EOF
    chmod +x $out/bin/diylc

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multi platform circuit layout and schematic drawing tool";
    homepage = "https://bancika.github.io/diy-layout-creator/";
    changelog = "https://github.com/bancika/diy-layout-creator/releases";
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
