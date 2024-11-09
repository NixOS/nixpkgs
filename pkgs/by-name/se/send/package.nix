{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "send";
  version = "3.4.23";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "send";
    rev = "refs/tags/v${version}";
    hash = "sha256-bqQEXLwUvTKX+m2yNHRnrl+eeaGmcovXpXugxd+j14A=";
  };

  npmDepsHash = "sha256-r1iaurKuhpP0sevB5pFdtv9j1ikM1fKL7Jgakh4FzTI=";

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

    makeWrapper ${lib.getExe nodejs} $out/bin/send \
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
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "send";
  };
}
