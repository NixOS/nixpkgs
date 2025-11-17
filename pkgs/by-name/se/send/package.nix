{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs_20,
  nixosTests,
}:
buildNpmPackage rec {
  pname = "send";
  version = "3.4.27";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "send";
    tag = "v${version}";
    hash = "sha256-tfntox8Sw3xzlCOJgY/LThThm+mptYY5BquYDjzHonQ=";
  };

  npmDepsHash = "sha256-ZVegUECrwkn/DlAwqx5VDmcwEIJV/jAAV99Dq29Tm2w=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
  };

  makeCacheWritable = true;

  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  postInstall = ''
    cp -r dist $out/lib/node_modules/send/
    ln -s $out/lib/node_modules/send/dist/version.json $out/lib/node_modules/send/version.json

    makeWrapper ${lib.getExe nodejs_20} $out/bin/send \
      --add-flags $out/lib/node_modules/send/server/bin/prod.js \
      --set "NODE_ENV" "production"
  '';

  passthru.tests = {
    inherit (nixosTests) send;
  };

  meta = {
    description = "File Sharing Experiment";
    changelog = "https://github.com/timvisee/send/releases/tag/v${version}";
    homepage = "https://github.com/timvisee/send";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      moraxyc
      MrSom3body
    ];
    mainProgram = "send";
  };
}
