{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "davis";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZoNd4RvHKdKhfWZN8KrDBGvRbLG6SWUytVEuCQRlnG4=";
  };

  composerNoPlugins = false;
  vendorHash = "sha256-Cpwr8YP1WiMW/ki7WK4zu88ycULP31vXbsqnzYEFHKs=";

  postInstall = ''
    chmod -R u+w $out/share
    # Only include the files needed for runtime in the derivation
    mv $out/share/php/davis/{migrations,public,src,config,bin,templates,tests,translations,vendor,symfony.lock,composer.json,composer.lock} $out
    # Save the upstream .env file for reference, but rename it so it is not loaded
    mv $out/share/php/davis/.env $out/env-upstream
    rm -rf "$out/share"
  '';

  passthru = {
    php = php;
    tests = {
      inherit (nixosTests) davis;
    };
  };

  meta = {
    changelog = "https://github.com/tchapi/davis/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/tchapi/davis";
    description = "Simple CardDav and CalDav server inspired by Baïkal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ramblurr ];
  };
})
