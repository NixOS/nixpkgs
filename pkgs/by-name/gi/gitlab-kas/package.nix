{
  buildGoModule,
  lib,
  fetchFromGitLab,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-kas";
  version = "18.6.3";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cluster-integration/gitlab-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-crKzUQ+51hRgQsICES4tULyrRFw+hjWN9jz+lxYjtew=";
  };

  vendorHash = "sha256-SSxQH45CVg1v8PKkbU046bAZsZOOPN5U7Cm81n82uRA=";
  subPackages = [ "./cmd/kas" ];

  ldflags =
    let
      goPkgPath = "gitlab.com/gitlab-org/cluster-integration/gitlab-agent/v${lib.versions.major finalAttrs.version}";
    in
    [
      "-X ${goPkgPath}/internal/cmd.Version=${finalAttrs.version}"
      "-X ${goPkgPath}/internal/cmd.GitRef=v${finalAttrs.version}"
    ];

  nativeInstallCheckHooks = [
    versionCheckHook
  ];

  meta = {
    description = "Kubernetes Agent (Gitlab side)";
    mainProgram = "kas";
    homepage = "https://gitlab.com/gitlab-org/cluster-integration/gitlab-agent";
    changelog = "https://gitlab.com/gitlab-org/cluster-integration/gitlab-agent/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.leona
    ];
  };
})
