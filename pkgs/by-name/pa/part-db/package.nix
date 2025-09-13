{
  stdenv,
  php,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  envLocalPath ? "/var/lib/part-db/env.local",
  cachePath ? "/var/cache/part-db/",
  logPath ? "/var/log/part-db/",
}:
let
  pname = "part-db";
  version = "1.14.5";

  srcWithVendor = php.buildComposerProject2 ({
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Part-DB";
      repo = "Part-DB-server";
      tag = "v${version}";
      hash = "sha256-KtNWog4aSnmgJsFckDuBrlnd9cj1f8kmSFi+nv2cZOg=";
    };

    patches = [
      ./fix-composer-validate.diff
    ];

    php = php.buildEnv {
      extensions = (
        { enabled, all }:
        enabled
        ++ (with all; [
          xsl
        ])
      );
    };

    vendorHash = "sha256-k47f6SSsQvNfhSIvNYfh+lEs9mVS3bxcVeqbKn5XjrY=";

    composerNoPlugins = false;

    postInstall = ''
      chmod -R u+w $out/share
      mv "$out"/share/php/part-db/* $out/
      mv "$out"/share/php/part-db/.* $out/
      cd $out/
      php -d memory_limit=256M bin/console cache:warmup
      rm -rf "$out/share"
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = srcWithVendor;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Mjss2UUHVUdJ4UAI3GkG6HB6g7LbJTqvgrIXFhZmw1Q=";
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

    rm -rf $out/var/{cache,log}
    ln -s ${envLocalPath} $out/.env.local
    ln -s ${logPath} $out/var/log
    ln -s ${cachePath} $out/var/cache
  '';

  meta = {
    description = "Open source inventory management system for your electronic components";
    homepage = "https://docs.part-db.de/";
    changelog = "https://github.com/Part-DB/Part-DB-server/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
