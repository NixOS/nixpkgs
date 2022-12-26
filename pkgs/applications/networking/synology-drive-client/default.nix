{ stdenv, lib, writeScript, qt5, fetchurl, autoPatchelfHook, dpkg, glibc, cpio, xar, undmg, gtk3, pango, libxcb }:
let
  pname = "synology-drive-client";
  baseUrl = "https://global.download.synology.com/download/Utility/SynologyDriveClient";
  version = "3.2.0-13258";
  buildNumber = with lib; last (splitString "-" version);
  meta = with lib; {
    description = "Desktop application to synchronize files and folders between the computer and the Synology Drive server.";
    homepage = "https://www.synology.com/en-global/dsm/feature/drive";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jcouyang MoritzBoehme ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
  passthru.updateScript = writeScript "update-synology-drive-client" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts

    set -eu -o pipefail

    version="$(curl -s https://www.synology.com/en-uk/releaseNote/SynologyDriveClient \
             | grep -oP '(?<=data-version=")(\d.){2}\d-\d{5}' \
             | head -1)"
    update-source-version synology-drive-client "$version"
  '';

  linux = qt5.mkDerivation {
    inherit pname version meta passthru;

    src = fetchurl {
      url = "${baseUrl}/${version}/Ubuntu/Installer/x86_64/synology-drive-client-${buildNumber}.x86_64.deb";
      sha256 = "sha256-jnMwhirZphguW+hluhzD9aXDTQ9RuJgAtjh+Iy23c3w=";
    };

    nativeBuildInputs = [ autoPatchelfHook dpkg ];

    buildInputs = [ glibc gtk3 pango libxcb ];

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
    inherit pname version meta passthru;

    src = fetchurl {
      url = "${baseUrl}/${version}/Mac/Installer/synology-drive-client-${buildNumber}.dmg";
      sha256 = "0hv0vgbvgqhzayc4przqhnkyvsykhw40hrwk6imvla00nix853wy";
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
