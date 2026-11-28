{
  stdenv,
  php,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  nixosTests,
  envLocalPath ? "/var/lib/part-db/env.local",
  cachePath ? "/var/cache/part-db/",
  logPath ? "/var/log/part-db/",
  mediaPath ? "/var/lib/part-db/public/media/",
  uploadsPath ? "/var/lib/part-db/uploads/",
}:
let
  pname = "part-db";
  version = "2.21.2";

  srcWithVendor = php.buildComposerProject2 {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Part-DB";
      repo = "Part-DB-server";
      tag = "v${version}";
      hash = "sha256-9kZcqsxQzLUSaCWKub0SKjUYQedLsRzL+9+vNQZ27rY=";
    };

    php = php.buildEnv {
      extensions = (
        { enabled, all }:
        enabled
        ++ (with all; [
          xsl
        ])
      );
    };

    vendorHash = "sha256-iRDEy+509opV9UERuygnrlvotsXr5vTkZaUi+aaGbA4=";

    # Upstream composer.json file is missing the description field
    composerStrictValidation = false;
    composerNoPlugins = false;

    postInstall = ''
      chmod -R u+w $out/share
      cd "$out"/share/php/part-db
      echo "Running composer dump-autoload to generate autoload_runtime.php..."
      composer dump-autoload --no-interaction
      export APP_ENV=prod
      export APP_SECRET=dummy
      export DATABASE_URL=sqlite:///%kernel.project_dir%/data/app.db
      php -d memory_limit=256M bin/console cache:warmup
      cd /build
      mv "$out"/share/php/part-db/* $out/
      mv "$out"/share/php/part-db/.* $out/
      rm -rf "$out/share"
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = srcWithVendor;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-oJwzGrT8czSVpX+8VUFUD4P9r5Udg5Fqr5QWj8AWnDQ=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    rm -r node_modules
    mkdir $out
    mv * .* $out/

    rm -rf $out/var/{cache,log} $out/public/media $out/uploads
    ln -s ${envLocalPath} $out/.env.local
    ln -s ${logPath} $out/var/log
    ln -s ${cachePath} $out/var/cache
    ln -s ${mediaPath} $out/public/media
    ln -s ${uploadsPath} $out/uploads
  '';

  passthru.tests = { inherit (nixosTests) part-db; };

  meta = {
    description = "Open source inventory management system for your electronic components";
    homepage = "https://docs.part-db.de/";
    changelog = "https://github.com/Part-DB/Part-DB-server/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      felbinger
      oddlama
    ];
    platforms = lib.platforms.linux;
  };
})
