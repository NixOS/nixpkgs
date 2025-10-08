{
  php,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "kimai";
  version = "2.40.0";

  src = fetchFromGitHub {
    owner = "kimai";
    repo = "kimai";
    tag = finalAttrs.version;
    hash = "sha256-/962VDi/50PMfSjMtJtlR9uIbJSzkF7kSQiRzb6o+SI=";
  };

  php = php.buildEnv {
    extensions = (
      { enabled, all }:
      enabled
      ++ (with all; [
        gd
        intl
        mbstring
        pdo
        tokenizer
        xsl
        zip
      ])
    );

    # Asset building and (later) cache building process requires a little bit
    # more memory.
    extraConfig = ''
      memory_limit=384M
    '';
  };

  vendorHash = "sha256-I4v4WkPGLc8vBPjCiYzPxcLn4rH3HWtQXSqwGVKXeGg=";

  composerNoPlugins = false;
  composerNoScripts = false;

  postInstall = ''
    # Make available the console utility, as Kimai doesn't list this in
    # composer.json.
    mkdir -p "$out"/share/php/kimai "$out"/bin
    ln -s "$out"/share/php/kimai/bin/console "$out"/bin/console
  '';

  passthru.tests = {
    kimai = nixosTests.kimai;
  };

  meta = {
    description = "Web-based multi-user time-tracking application";
    homepage = "https://www.kimai.org/";
    license = lib.licenses.agpl3Plus;
    longDescription = "
      Kimai is a web-based multi-user time-tracking application. Works great for
      everyone: freelancers, companies, organizations - everyone can track their
      times, generate reports, create invoices and do so much more.
    ";
    maintainers = with lib.maintainers; [ peat-psuwit ];
    platforms = lib.platforms.all;
  };
})
