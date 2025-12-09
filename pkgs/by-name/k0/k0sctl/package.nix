{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  k0sctl,
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = "k0sctl";
    tag = "v${version}";
    hash = "sha256-U9wrm/XHydO9BzVN0p1Gx6mz34k2rBknYRmqYkD+vR8=";
  };

  vendorHash = "sha256-rNbnJmyh+97384s8Pse2ljTRPAtrl8jksbRwNxqqQUU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/k0sproject/k0sctl/version.Environment=production"
    "-X=github.com/carlmjohnson/versioninfo.Version=v${version}" # Doesn't work currently: https://github.com/carlmjohnson/versioninfo/discussions/12
    "-X=github.com/carlmjohnson/versioninfo.Revision=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd ${pname} \
        --$shell <($out/bin/${pname} completion --shell $shell)
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = k0sctl;
    command = "k0sctl version";
    # See https://github.com/carlmjohnson/versioninfo/discussions/12
    version = "version: (devel)\ncommit: v${version}\n";
  };

  meta = {
    description = "Bootstrapping and management tool for k0s clusters";
    homepage = "https://k0sproject.io/";
    changelog = "https://github.com/k0sproject/k0sctl/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "k0sctl";
    maintainers = with lib.maintainers; [
      nickcao
      qjoly
    ];
  };
}
