{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  testers,
  k0sctl,
}:

buildGo127Module (finalAttrs: {
  pname = "k0sctl";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = "k0sctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g/8rN0UWbUjiIuWKcBb9sr8PjMx+rcq3Hce64cGziU0=";
  };

  vendorHash = "sha256-3TIQ1VY+52DFCVWiJs5U+5A+mVSU3QPyr5Vzrzs7zF8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/k0sproject/k0sctl/version.Environment=production"
    "-X=github.com/carlmjohnson/versioninfo.Version=v${finalAttrs.version}" # Doesn't work currently: https://github.com/carlmjohnson/versioninfo/discussions/12
    "-X=github.com/carlmjohnson/versioninfo.Revision=v${finalAttrs.version}"
  ];

  checkFlags = [
    # requires sudo
    "-skip=^TestLocalBinaryProviderCreatesParentDir$"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd ${finalAttrs.pname} \
        --$shell <($out/bin/${finalAttrs.pname} completion --shell $shell)
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = k0sctl;
    command = "k0sctl version";
    # See https://github.com/carlmjohnson/versioninfo/discussions/12
    version = "version: (devel)\ncommit: v${finalAttrs.version}\n";
  };

  meta = {
    description = "Bootstrapping and management tool for k0s clusters";
    homepage = "https://k0sproject.io/";
    changelog = "https://github.com/k0sproject/k0sctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "k0sctl";
    maintainers = with lib.maintainers; [
      nickcao
      qjoly
    ];
  };
})
