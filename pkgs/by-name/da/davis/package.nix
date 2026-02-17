{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "davis";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YLVfcoC8cIcCfi7R2zWXNxD4P+KIXOCL+MqFEt2Z7Tc=";
  };

  composerNoPlugins = false;
  vendorHash = "sha256-VpINHPy2gwA5dk8OGQjmWnCpS9JVyEAUG+bptggCybk=";

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
