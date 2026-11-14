{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdk8s-cli";
  version = "2.207.81";

  src = fetchFromGitHub {
    owner = "cdk8s-team";
    repo = "cdk8s-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zk0h9EK+NTrMCA1wdY3ilX4oEYMGouHPGopefpAof/8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-q0q1Ob7bjpdDzTiFDkGqC+UZycsD4ZqEobC3smgS68c=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  # Skip tests, they need network access
  env.SKIP_TESTS = 1;

  # Set the version properly, setting it earlier makes the build fail
  # because `projen` requires a version of 0.0.0 in the package.json
  postInstall = ''
    substituteInPlace $out/lib/node_modules/cdk8s-cli/package.json \
      --replace-fail '0.0.0' '${finalAttrs.version}'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line-interface for CDK for Kubernetes";
    homepage = "https://github.com/cdk8s-team/cdk8s-cli";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "cdk8s";
  };
})
