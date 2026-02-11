{
  lib,
  buildNpmPackage,
  nodejs,
  makeWrapper,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "aws-cloudformation-languageserver";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cloudformation-languageserver";
    rev = "v${version}";
    sha256 = "sha256-cPI6cRuLSFbL3G3peLkIeF+9BBJye7oURBQtuErs4gQ=";
  };
  npmDepsHash = "sha256-f7x+yXov2qswX7WEiWT6k0p4hVYF79iXStGHM8FkRBg=";
  dontNpmBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    # disable webpack InstallDependencies hook,
    # instead use buildNpmPackage node_modules
    substituteInPlace webpack.config.js \
      --replace-fail \
        "compiler.hooks.beforeRun.tapAsync('InstallDependencies', (compilation, callback) => {" \
        "compiler.hooks.beforeRun.tapAsync('InstallDependencies', (compilation, callback) => { return callback();" \
      --replace-fail \
        "compiler.hooks.done.tap('CleanupTemp', () => {" \
        "compiler.hooks.done.tap('CleanupTemp', () => { return;" \
      --replace-fail \
        "path.join('tmp-node-modules', 'node_modules')" \
        "'node_modules'" \
      --replace-fail \
        "'tmp-node-modules/package.json'" \
        "'package.json'"

    ./node_modules/.bin/webpack --env mode=production --env env=prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/aws-cloudformation-languageserver
    cp -r bundle/production/* $out/lib/aws-cloudformation-languageserver/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/cfn-lsp-server \
      --add-flags "$out/lib/aws-cloudformation-languageserver/cfn-lsp-server-standalone.js"

    runHook postInstall
  '';

  meta = {
    description = "CloudFormation Language Server";
    mainProgram = "cfn-lsp-server";
    homepage = "https://github.com/aws-cloudformation/cloudformation-languageserver";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
    maintainers = with lib.maintainers; [
      mbarneyjr
    ];
  };
}
