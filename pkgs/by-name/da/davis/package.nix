{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "davis";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z2e5QRyyJeisWLi2tZJZNAXrO3/DL6v2Nvxd0+SC6EU=";
  };

  vendorHash = "sha256-ee3Gvg8rvX9jelmSVHjFltZz9R+7w2B8L4gjv3GaN/g=";

  composerNoPlugins = false;

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
