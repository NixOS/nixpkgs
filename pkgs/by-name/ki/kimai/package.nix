{
  php,
  fetchFromGitHub,
  fetchpatch2,
  lib,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "kimai";
  version = "2.46.0";

  src = fetchFromGitHub {
    owner = "kimai";
    repo = "kimai";
    tag = finalAttrs.version;
    hash = "sha256-sZjDl3nQ4i5KVnM2fLVvaQxMlE225q7EBkgFmTn+ugc=";
  };

  patches = [
    # https://github.com/kimai/kimai/pull/5849
    (fetchpatch2 {
      name = "CVE-2026-28685.patch";
      url = "https://github.com/kimai/kimai/commit/a0601c8cb28fed1cca19051a8272425069ab758f.patch?full_index=1";
      # Kimai specifies `tests export-ignore` in its `.gitattributes`, and
      # `fetchFromGitHub` uses export archive from GitHub.
      excludes = [ "tests/*" ];
      hash = "sha256-LOGyGpkhfDBOy9MojJMm9IIlqqeGqKAejfLVIX6FnJw=";
    })
  ];

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

  vendorHash = "sha256-GuaPJVE97WHediCi7kbGk/CqDR55H5lkpz/QHiBSk7A=";

  composerNoPlugins = false;

  postInstall = ''
    # Make available the console utility, as Kimai doesn't list this in
    # composer.json.
    mkdir -p "$out"/share/php/kimai "$out"/bin
    ln -s "$out"/share/php/kimai/bin/console "$out"/bin/console

    # Install bundled assets. This is normally done in the `composer install`
    # post-install script, but it's being skipped.
    (cd "$out"/share/php/kimai && php ./bin/console assets:install)
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
