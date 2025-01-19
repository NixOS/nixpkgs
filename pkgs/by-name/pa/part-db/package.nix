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
}:
let
  pname = "part-db";
  version = "1.14.5";

  srcWithVendor = php.buildComposerProject ({
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Part-DB";
      repo = "Part-DB-server";
      rev = "v${version}";
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

    vendorHash = "sha256-PJtm/3Vdm2zomUklVMKlDAe/vziJN4e+JNNf/u8N3B4=";

    composerNoPlugins = false;

    postInstall = ''
      mv "$out"/share/php/part-db/* $out/
      mv "$out"/share/php/part-db/.* $out/

      cd $out/
      php -d memory_limit=256M bin/console cache:warmup
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
  '';

  meta = {
    description = "Part-DB is an Open source inventory management system for your electronic components";
    homepage = "https://docs.part-db.de/";
    changelog = "https://github.com/Part-DB/Part-DB-server/releases/tag/${srcWithVendor.src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
