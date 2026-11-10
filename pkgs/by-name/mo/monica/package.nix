{
  stdenv,
  lib,
  fetchurl,
  cacert,
  nixosTests,
  dataDir ? "/var/lib/monica",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "monica";
  version = "4.1.2";

  src = fetchurl {
    url = "https://github.com/monicahq/monica/releases/download/v${finalAttrs.version}/monica-v${finalAttrs.version}.tar.bz2";
    hash = "sha256-7ZdOSI/gldSWub5FIyYQw3gpLe+PRAnq03u6DXdZ2YE=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -R * $out/
    rm $out/vendor/composer/ca-bundle/res/cacert.pem
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/vendor/composer/ca-bundle/res/cacert.pem
    rm $out/vendor/stripe/stripe-php/data/ca-certificates.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/vendor/stripe/stripe-php/data/ca-certificates.crt
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
})
