{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
  nix-update-script,
  dataDir ? "/var/lib/bookstack",
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "bookstack";
  version = "25.02";

  src = fetchFromGitHub {
    owner = "bookstackapp";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Aj9R9+jXqq2Th76kfED5ZfZaMyFyK6c8r4LwXGMomL0=";
  };

  vendorHash = "sha256-VFGCV8g6ph3TckpJQMk0g/F256Mz0t0VFW52jzBfmm0=";

  passthru = {
    phpPackage = php;
    tests = nixosTests.bookstack;
    updateScript = nix-update-script { };
  };

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/${finalAttrs.pname}/* $out
    rm -R $out/share $out/storage $out/bootstrap/cache $out/public/uploads
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
    ln -s ${dataDir}/public/uploads $out/public/uploads
  '';

  meta = with lib; {
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
