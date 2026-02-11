{
  lib,
  buildNpmPackage,
  nodejs,
  makeWrapper,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "aws-cloudformation-languageserver";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cloudformation-languageserver";
    rev = "v${version}";
    sha256 = "sha256-Oh9fuA3cDd9XWT0FaD4Anadx0CFTL6ggryYhP5pUAKk=";
  };

  npmDepsHash = "sha256-Qd6F5og3DwboWHq1t1bIqYsUUfS68f+e19L23t8/AqU=";

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

    ./node_modules/.bin/webpack --env mode=production --env env=prod --env skipWheels=true

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

  __structuredAttrs = true;

  meta = {
    description = "CloudFormation Language Server";
    mainProgram = "cfn-lsp-server";
    homepage = "https://github.com/aws-cloudformation/cloudformation-languageserver";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      mbarneyjr
    ];
  };
}
