{
  php,
  fetchFromGitLab,
  lib,
  nixosTests,
  dataDir ? "/var/lib/pollaris",
  # Optional customisation, see https://framagit.org/pollaris/pollaris/-/blob/main/docs/administrators/install.md
  customCss ? null,
  customJs ? null,
  customHomeTemplate ? null,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "pollaris";
  version = "1.2.3";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "pollaris";
    repo = "pollaris";
    tag = finalAttrs.version;
    hash = "sha256-8eFJbsPWSgHHnKHQOKMv/FjXQeT+gWXmINdPDnL2cwM=";
  };

  php = php.buildEnv {
    extensions = (
      { enabled, all }:
      enabled
      ++ (with all; [
        intl
        pdo_pgsql
        zip
      ])
    );
  };

  vendorHash = "sha256-EwJ/rAOa88cZf2jC5YuqVW69tRtokky34nS3ch9zUPc=";

  composerNoPlugins = false; # for Symfony Runtime

  postInstall = ''
    # Make available the console utility, which is not listed in composer.json.
    mkdir -p "$out"/bin
    ln -s "$out"/share/php/pollaris/bin/console "$out"/bin/pollaris-console

    # The cache, logs and configuration must be writable at runtime.
    rm -rf "$out"/share/php/pollaris/var
    ln -s ${dataDir} "$out"/share/php/pollaris/var
    ln -s ${dataDir}/.env.local "$out"/share/php/pollaris/.env.local
  ''
  + lib.optionalString (customCss != null) ''
    ln -s ${customCss} "$out"/share/php/pollaris/public/custom.css
  ''
  + lib.optionalString (customJs != null) ''
    ln -s ${customJs} "$out"/share/php/pollaris/public/custom.js
  ''
  + lib.optionalString (customHomeTemplate != null) ''
    ln -s ${customHomeTemplate} "$out"/share/php/pollaris/templates/home/custom.html.twig
  '';

  passthru.tests = {
    inherit (nixosTests) pollaris;
  };

  meta = {
    description = "Polling tool to plan, organise and make decisions quickly";
    homepage = "https://pollaris.org";
    changelog = "https://framagit.org/pollaris/pollaris/-/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    mainProgram = "pollaris-console";
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.all;
  };
})
