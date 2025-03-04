{ lib
, fetchFromGitHub
, php
, nixosTests
, nix-update-script
, dataDir ? "/var/lib/pixelfed"
, runtimeDir ? "/run/pixelfed"
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "pixelfed";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "pixelfed";
    repo = "pixelfed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HEo0BOC/AEWhCApibxo2TBQF4kbLrbPEXqDygVQlVic=";
  };

  vendorHash = "sha256-aMKuuBTavNTIfYkuAn2vBFeh5xJd3BY8C+IVfglnS+g=";

  postInstall = ''
    chmod -R u+w $out/share
    mv "$out/share/php/${finalAttrs.pname}"/* $out
    rm -R $out/bootstrap/cache
    # Move static contents for the NixOS module to pick it up, if needed.
    mv $out/bootstrap $out/bootstrap-static
    mv $out/storage $out/storage-static
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/storage $out/
    ln -s ${dataDir}/storage/app/public $out/public/storage
    ln -s ${runtimeDir} $out/bootstrap
    chmod +x $out/artisan
  '';

  passthru = {
    tests = { inherit (nixosTests) pixelfed; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Federated image sharing platform";
    license = licenses.agpl3Only;
    homepage = "https://pixelfed.org/";
    maintainers = [ ];
    platforms = php.meta.platforms;
  };
})
