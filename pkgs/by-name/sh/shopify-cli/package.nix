{
  buildNpmPackage,
  lib,
  makeWrapper,
  bundlerEnv,
  testers,
  shopify-cli,
}:
let
  version = "3.63.2";

  # Package the legacy ruby CLI.
  rubyGems = bundlerEnv {
    name = "shopify-cli-legacy";
    gemdir = ./.;
  };
in
buildNpmPackage {
  pname = "shopify";
  version = version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset =
      with lib.fileset;
      unions [
        ./package.json
        ./package-lock.json
      ];
  };

  npmDepsHash = "sha256-6CEDcWXZXYHFrT2xpbj5NwMrbDZXH6HclgTGkfKDlJs=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = shopify-cli;
      command = "shopify version";
    };
  };

  postInstall = ''
    # Disable the installCLIDependencies function.
    substituteInPlace $(grep -r -l 'await installCLIDependencies' $out/lib/node_modules/shopify/node_modules/@shopify/cli/dist) \
      --replace-fail 'await installCLIDependencies' '// await installCLIDependencies'

    wrapProgram $out/bin/shopify \
      --set SHOPIFY_RUBY_BINDIR  ${rubyGems.wrappedRuby}/bin \
      --prefix PATH : ${rubyGems}/bin \
      --set SHOPIFY_CLI_VERSION ${version} \
      --set SHOPIFY_CLI_BUNDLED_THEME_CLI 0
  '';

  meta = {
    platforms = lib.platforms.all;
    mainProgram = "shopify";
    description = "CLI which helps you build against the Shopify platform faster";
    homepage = "https://github.com/Shopify/cli";
    changelog = "https://github.com/Shopify/cli/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fd
      onny
    ];
  };
}
