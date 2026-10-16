{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "davis";
  version = "5.4.4";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XGnBXJhAX1hsLOO/dujdf/EUBmaPmW7Kt5e23pabVdU=";
  };

  composerNoPlugins = false;
  vendorHash = "sha256-hGLGnF0670jDtZ5m5TH+4ewXMByvt8eL+WoCeATIvDU=";

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
