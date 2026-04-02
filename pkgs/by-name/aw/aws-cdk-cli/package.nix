{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  diffutils,
  zip,
  jq,
  unzip,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-cdk-cli";
  version = "2.1104.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cdk-cli";
    tag = "cdk@v${finalAttrs.version}";
    hash = "sha256-bIrTc87gk14ckVhcoZKa1aOo0wpWZCceafpxzKLcDEY=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-JuklEESNm/eadB5iBvomfY87NRaPywEnwL2GtPUTQ2Y=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    zip
    jq
    # tests
    diffutils
    unzip
  ];

  env = {
    NX_DISABLE_REMOTE_CACHE = "true";
    NX_TASKS_RUNNER_DYNAMIC_OUTPUT = "false";
    NX_VERBOSE_LOGGING = "true";
    # Needed to properly embed version info
    CODEBUILD_RESOLVED_SOURCE_VERSION = finalAttrs.version;
  };

  # Regular "build" is very heavy and does things we don't need.
  yarnBuildScript = "compile";

  postPatch =
    let
      cliVersionJson = builtins.toJSON {
        inherit (finalAttrs) version;
      };
    in
    ''
      echo '${cliVersionJson}' > packages/@aws-cdk/cloud-assembly-schema/cli-version.json
    '';

  preBuild = ''
    export NX_PARALLEL="$NIX_BUILD_CORES"
    pushd packages/@aws-cdk/integ-runner
    patchShebangs build-tools/generate.sh
    build-tools/generate.sh
    popd
    pushd packages/aws-cdk
    patchShebangs generate.sh
    ./generate.sh
    popd
  '';

  postInstall = ''
    # Manually bundle non-bundled dependencies
    cp -r packages/@aws-cdk/cloud-assembly-schema/node_modules/jsonschema $out/lib/node_modules/aws-cdk-cli/node_modules/jsonschema
    cp -r packages/aws-cdk/node_modules/decamelize $out/lib/node_modules/aws-cdk-cli/node_modules/decamelize

    patchShebangs "$out/lib/node_modules/aws-cdk-cli/node_modules/aws-cdk/bin"
    ln -s "$out/lib/node_modules/aws-cdk-cli/node_modules/aws-cdk/bin" "$out/bin"
    # Delete broken symlinks
    find "$out/lib/node_modules" -xtype l -delete

    # Fix version
    pushd $out/lib/node_modules/aws-cdk-cli/packages/aws-cdk
    mv package.json package.json.bak
    jq '.version = "${finalAttrs.version}"' < package.json.bak > package.json
    rm package.json.bak
    mv build-info.json bi.json
    jq '.commit = "nixpkgs"' < bi.json > build-info.json
    rm bi.json
    popd
  '';

  # Fixup takes an absurdly long time, so disable it
  dontFixup = true;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "cdk@v(.*)"
      ];
    };
  };

  meta = {
    description = "AWS CDK Toolkit";
    homepage = "https://docs.aws.amazon.com/cdk/v2/guide/cli.html";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "cdk";
    platforms = lib.platforms.all;
  };
})
