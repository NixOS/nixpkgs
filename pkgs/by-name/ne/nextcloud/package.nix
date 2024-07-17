{ lib
, stdenvNoCC
, fetchurl
, nixosTests
, nextcloud29Packages
}:
stdenvNoCC.mkDerivation rec {
  pname = "nextcloud";
  version = "29.0.3";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
    hash = "sha256-pZludkwSCSf4hE2PWyjHNrji8ygLEgvhOivXcxzbf9Q=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    runHook postInstall
  '';

  passthru = {
    tests = nixosTests.nextcloud;
    packages = nextcloud29Packages;
  };

  meta = with lib; {
    changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = "https://nextcloud.com";
    maintainers = with maintainers; [ schneefux bachp globin ma27 ];
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
  };
}
