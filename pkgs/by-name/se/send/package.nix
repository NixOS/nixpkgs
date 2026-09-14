{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs_22,
  nix-update-script,
  nixosTests,
}:
buildNpmPackage (finalAttrs: {
  pname = "send";
  version = "3.4.27";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "send";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tfntox8Sw3xzlCOJgY/LThThm+mptYY5BquYDjzHonQ=";
  };

  # @dannycoates/express-ws uses the unmaintained esm loader, which fails on nodejs_22.
  postConfigure = ''
    patch -p1 \
      --directory=node_modules/@dannycoates \
      < ${./dannycoates-express-ws-drop-esm-loader.patch}
  '';

  nodejs = nodejs_22;

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-QInXcYpZcAOJMS6QFtIapftyWsqA80ef+OiKJ9XEs98=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  npmPackFlags = [ "--ignore-scripts" ];

  postInstall = ''
    cp -r dist $out/lib/node_modules/send/
    ln -s $out/lib/node_modules/send/dist/version.json $out/lib/node_modules/send/version.json

    makeWrapper ${lib.getExe finalAttrs.nodejs} $out/bin/send \
      --add-flags $out/lib/node_modules/send/server/bin/prod.js \
      --set "NODE_ENV" "production"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) send;
    };
  };

  meta = {
    description = "File Sharing Experiment";
    changelog = "https://github.com/timvisee/send/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/timvisee/send";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      moraxyc
      MrSom3body
    ];
    mainProgram = "send";
  };
})
