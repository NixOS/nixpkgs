{
  lib,
  stdenv,
  fetchurl,
  nix-update-script,
  testers,
  jre,
  makeWrapper,
  mysqlSupport ? true,
  mysql_jdbc,
  postgresqlSupport ? true,
  postgresql_jdbc,
  redshiftSupport ? true,
  redshift_jdbc,
  liquibase_redshift_extension,
}:

let
  extraJars =
    lib.optional mysqlSupport mysql_jdbc
    ++ lib.optional postgresqlSupport postgresql_jdbc
    ++ lib.optionals redshiftSupport [
      redshift_jdbc
      liquibase_redshift_extension
    ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "liquibase";
  version = "5.0.4";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/v${finalAttrs.version}/liquibase-${finalAttrs.version}.tar.gz";
    hash = "sha256-uwhjjXDd3Wr4zKbgMxSFdvghS1mWgxsfiGTrNSj0z84=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  sourceRoot = ".";

  installPhase =
    let
      addJars = dir: ''
        for jar in ${dir}/*.jar; do
          CP="\$CP":"\$jar"
        done
      '';
    in
    ''
      mkdir -p $out
      mv ./{lib,licenses} $out/

      mkdir -p $out/internal/lib
      mv ./internal/lib/*.jar $out/internal/lib/

      mkdir -p $out/share/doc/liquibase-${finalAttrs.version}
      mv LICENSE.txt \
         README.txt \
         ABOUT.txt \
         changelog.txt \
         $out/share/doc/liquibase-${finalAttrs.version}

      mkdir -p $out/bin
      # there’s a lot of escaping, but I’m not sure how to improve that
      cat > $out/bin/liquibase <<EOF
      #!/usr/bin/env bash
      export LIQUIBASE_ANALYTICS_ENABLED="\''${LIQUIBASE_ANALYTICS_ENABLED:-false}"
      # taken from the executable script in the source
      CP=""
      ${addJars "$out/internal/lib"}
      ${addJars "$out/lib"}
      ${addJars "$out"}
      ${lib.concatStringsSep "\n" (map (p: addJars "${p}/share/java") extraJars)}
      ${lib.getBin jre}/bin/java -cp "\$CP" \$JAVA_OPTS \
      liquibase.integration.commandline.LiquibaseCommandLine \''${1+"\$@"}
      EOF
      chmod +x $out/bin/liquibase
    '';

  # Upstream tags things it never releases -- v5.0.4 exists right now with no
  # release behind it -- so ask the release endpoint rather than the tags.
  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Version Control for your database";
    mainProgram = "liquibase";
    homepage = "https://www.liquibase.org/";
    changelog = "https://raw.githubusercontent.com/liquibase/liquibase/v${finalAttrs.version}/changelog.txt";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    # Relicensed at 5.0.0. The FSL permits internal and commercial use but
    # forbids competing products, so it is unfree by our definition; each
    # release additionally becomes Apache-2.0 two years after publication.
    license = lib.licenses.fsl11Asl20;
    maintainers = with lib.maintainers; [
      agilesteel
      jsoo1
    ];
    platforms = with lib.platforms; unix;
  };
})
