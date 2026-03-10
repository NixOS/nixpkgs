{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud33Packages,
  nextcloudPackages ? nextcloud33Packages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nextcloud";
  version = "33.0.0";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/nextcloud-${finalAttrs.version}.tar.bz2";
    hash = "sha256-b3cwkCJpyHn58q1KoKInyxa1QI7kbwk/aL0yYz90Gr8=";
  };

  passthru = {
    tests = nixosTests.nextcloud;
    packages = nextcloudPackages;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    runHook postInstall
  '';

  meta = {
    changelog = "https://nextcloud.com/changelog/#${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = "https://nextcloud.com";
    teams = [ lib.teams.nextcloud ];
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
})
