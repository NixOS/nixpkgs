{
  lib,
  fetchFromGitHub,
  php83,
  nixosTests,
  dataDir ? "/var/lib/bookstack",
}:

php83.buildComposerProject2 (finalAttrs: {
  pname = "bookstack";
  version = "25.11.4";

  src = fetchFromGitHub {
    owner = "bookstackapp";
    repo = "bookstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hyob7OF9AOsu4AjS6qu8A93AsumSXiyWPDKWGAz6mJ0=";
  };

  vendorHash = "sha256-srlqwp0/Gfs6hWO9IGSCwR3yTxz+euYgoVkU+UnaLio=";

  passthru = {
    phpPackage = php83;
    tests = nixosTests.bookstack;
  };

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/bookstack/* $out
    rm -R $out/share $out/storage $out/bootstrap/cache $out/public/uploads $out/themes
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
    ln -s ${dataDir}/public/uploads $out/public/uploads
    ln -s ${dataDir}/themes $out/themes
  '';

  meta = {
    description = "Platform to create documentation/wiki content built with PHP & Laravel";
    longDescription = ''
      A platform for storing and organising information and documentation.
      Details for BookStack can be found on the official website at https://www.bookstackapp.com/.
    '';
    homepage = "https://www.bookstackapp.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ymarkus
      savyajha
    ];
    platforms = lib.platforms.linux;
  };
})
