{
  lib,
  buildNpmPackage,
  nodejs,
  makeWrapper,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "aws-cloudformation-languageserver";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cloudformation-languageserver";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-wQ8KOoXe4p+k3qJBxeuRmRibqy8kUgM9NLX8S3wb9Mc=";
  };

  npmDepsHash = "sha256-Hw1u5LFZ0+Ls1xZD1FInAJdAbtdjEhL8DWLTxxkJkW4=";

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
  # buildNpmPackage's hooks read these as plain env vars; under
  # __structuredAttrs they are bash variables that need to be exported.
  prePatch = "export npmDeps";

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
})
