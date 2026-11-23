{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.597";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    tag = "v${finalAttrs.version}";
    # Record the commit SHA for `nsc version`, then drop .git for reproducibility
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/COMMIT
      find $out -name .git -print0 | xargs -0 rm -rf
    '';
    hash = "sha256-Pe7cF7IEN2+DJ9DHmcEoIFeOs/BLIiM6miTg+v+jm/o=";
  };

  vendorHash = "sha256-GDQtz2x5mQpsPbAPmFz4LXWhcrNjTeF85I7v+jDxpTY=";

  # The version code requires vcs.revision from Go's embedded build info,
  # which is only stamped when building inside a git checkout. Use the
  # commit recorded at fetch time so `nsc version` (and `nsc doctor`) work.
  postPatch = ''
    substituteInPlace internal/cli/version/version.go \
      --replace-fail 'var revision, buildtime string' "revision, buildtime := \"$(cat COMMIT)\", \"\""
  '';

  subPackages = [
    "cmd/nsc"
    "cmd/ns"
    "cmd/docker-credential-nsc"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X namespacelabs.dev/foundation/internal/cli/version.Tag=v${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    mainProgram = "nsc";
    maintainers = with lib.maintainers; [ techknowlogick ];
    license = lib.licenses.asl20;
    changelog = "https://github.com/namespacelabs/foundation/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/namespacelabs/foundation";
    description = "Command line interface for the Namespaces platform";
  };
})
