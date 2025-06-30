{
  lib,
  fetchFromGitHub,
  php83,
  nixosTests,
  dataDir ? "/var/lib/bookstack",
}:

php83.buildComposerProject2 (finalAttrs: {
  pname = "bookstack";
  version = "25.05.1";

  src = fetchFromGitHub {
    owner = "bookstackapp";
    repo = "bookstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wQ5i9A+uCD9srSuEnTWWgALzlbciPVwfYhy8ZKVsX7E=";
  };

  vendorHash = "sha256-ApLBU21CrmYVW1lOX1wFTo5UMWUEErWumn8x742iMT0=";

  passthru = {
    phpPackage = php83;
    tests = nixosTests.bookstack;
  };

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/bookstack/* $out
    rm -R $out/share $out/storage $out/bootstrap/cache $out/public/uploads
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
    ln -s ${dataDir}/public/uploads $out/public/uploads
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
