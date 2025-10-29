{
  stdenv,
  lib,
  fetchurl,
  nixosTests,
  dataDir ? "/var/lib/monica",
}:
stdenv.mkDerivation rec {
  pname = "monica";
  version = "4.1.2";

  src = fetchurl {
    url = "https://github.com/monicahq/monica/releases/download/v${version}/monica-v${version}.tar.bz2";
    hash = "sha256-7ZdOSI/gldSWub5FIyYQw3gpLe+PRAnq03u6DXdZ2YE=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -R * $out/
    rm -rf $out/storage
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/storage $out/storage
  '';

  passthru.tests.monica = nixosTests.monica;

  meta = {
    description = "Personal CRM";
    homepage = "https://www.monicahq.com/";
    longDescription = ''
      Remember everything about your friends, family and business
      relationships.
    '';
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
  };
}
