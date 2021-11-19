{ lib, mkDerivation, fetchurl, autoPatchelfHook, dpkg, glibc, gnome }:

mkDerivation rec {
  pname = "synology-drive";
  subVersion = "12674";
  version = "3.0.1-${subVersion}";

  src = fetchurl {
    url = "https://global.download.synology.com/download/Utility/SynologyDriveClient/${version}/Ubuntu/Installer/x86_64/synology-drive-client-${subVersion}.x86_64.deb";
    sha256 = "1yyv6zgszsym22kf4jvlan7n9lw09fw24fyrh7c8pzbb2029gp8a";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ glibc gnome.nautilus ];

  unpackPhase = ''
    mkdir -p $out
    dpkg -x $src $out
  '';

  installPhase = ''
    # synology-drive executable
    cp -av $out/usr/* $out
    rm -rf $out/usr

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/bin/synology-drive --replace /opt $out/opt
  '';

  meta = with lib; {
    homepage = "https://www.synology.com/";
    description = "Synchronize files between client and Synology NAS.";
    longDescription = ''
      Drive for PC, the desktop utility of the DSM add-on package.
      Drive, allows you to sync and share files owned by you or shared by others between a centralized Synology NAS and multiple client computers.
    '';
    license = licenses.unfree;
    maintainers = with maintainers; [ MoritzBoehme ];
    platforms = [ "x86_64-linux" ];
  };
}
