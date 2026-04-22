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
  version = "2.206.3";

  src = fetchFromGitHub {
    owner = "cdk8s-team";
    repo = "cdk8s-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ezxwAhSxDSmP4DhT4vF8nuO+TcnWgLk5szJb3RIv1xg=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-fkG7gre4OOpoZf/vQAJU0Lnbl7eDsgZy0H/+4C7aWvI=";
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
