{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
  nix-update-script,
  dataDir ? "/var/lib/pixelfed",
  runtimeDir ? "/run/pixelfed",
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "pixelfed";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "pixelfed";
    repo = "pixelfed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FxJWoFNyIGQ6o9g2Q0/jaBMyeH8UnbTgha2goHAurvY=";
  };

  vendorHash = "sha256-ciHP6dE42pXupZl4V37RWcHkIZ+xf6cnpwqd3C1dNmQ=";

  postInstall = ''
    chmod -R u+w $out/share
    mv "$out/share/php/pixelfed"/* $out
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
    tests = { inherit (nixosTests.pixelfed) standard; };
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
