{ stdenv, lib, qt5, fetchurl, autoPatchelfHook, dpkg, glibc, cpio, xar, undmg, gtk3, pango }:
let
  pname = "synology-drive-client";
  baseUrl = "https://global.download.synology.com/download/Utility/SynologyDriveClient";
  buildNumber = "12920";
  version = "3.1.0";
  meta = with lib; {
    description = "Desktop application to synchronize files and folders between the computer and the Synology Drive server.";
    homepage = "https://www.synology.com/en-global/dsm/feature/drive";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jcouyang MoritzBoehme ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  linux = qt5.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "${baseUrl}/${version}-${buildNumber}/Ubuntu/Installer/x86_64/synology-drive-client-${buildNumber}.x86_64.deb";
      sha256 = "sha256-UAO/LwqPchIMhjdQP4METjVorMJsbvIDRkp4JxtZgOs=";
    };

    nativeBuildInputs = [ autoPatchelfHook dpkg ];

    buildInputs = [ glibc gtk3 pango ];

    unpackPhase = ''
      mkdir -p $out
      dpkg -x $src $out
      rm -rf $out/usr/lib/nautilus
      rm -rf $out/opt/Synology/SynologyDrive/package/cloudstation/icon-overlay
    '';

    installPhase = ''
      cp -av $out/usr/* $out
      rm -rf $out/usr
      runHook postInstall
    '';

    postInstall = ''
      substituteInPlace $out/bin/synology-drive --replace /opt $out/opt
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "${baseUrl}/${version}-${buildNumber}/Mac/Installer/synology-drive-client-${buildNumber}.dmg";
      sha256 = "15wici8ycil1mfh5cf89rfan4kb93wfkdsd4kmpvzjj4bnddwlxa";
    };

    nativeBuildInputs = [ cpio xar undmg ];

    postUnpack = ''
      xar -xf 'Install Synology Drive Client.pkg'
      cd synology-drive.installer.pkg
      gunzip -dc Payload | cpio -i
    '';

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications/
      cp -R 'Synology Drive Client.app' $out/Applications/
    '';
  };
in if stdenv.isDarwin then darwin else linux
