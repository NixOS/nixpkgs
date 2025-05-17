{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "davis";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VaI6KK/qV8uYaQi8peB5PteI2FNcef9ieamTq3bPDMk=";
  };

  vendorHash = "sha256-Zig79urr+KoQT15a0oBWV89iFFwjtH1EWJGebJbJ8mw=";

  postInstall = ''
    chmod -R u+w $out/share
    # Only include the files needed for runtime in the derivation
    mv $out/share/php/${finalAttrs.pname}/{migrations,public,src,config,bin,templates,tests,translations,vendor,symfony.lock,composer.json,composer.lock} $out
    # Save the upstream .env file for reference, but rename it so it is not loaded
    mv $out/share/php/${finalAttrs.pname}/.env $out/env-upstream
    rm -rf "$out/share"
  '';

  passthru.tests = {
    inherit (nixosTests) davis;
  };

  meta = {
    changelog = "https://github.com/tchapi/davis/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/tchapi/davis";
    description = "Simple CardDav and CalDav server inspired by Baïkal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ramblurr ];
  };
})
