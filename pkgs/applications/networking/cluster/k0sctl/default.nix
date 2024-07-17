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
  version = "0.17.8";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QHTVNrPglNDT9CUQWwc6oD7ttwEUBq8WIX49DiAXf8s=";
  };

  vendorHash = "sha256-6Kj1kHKXbbPMr9thkDTmGYbZvCSW7CvSzASpk6agEpI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/carlmjohnson/versioninfo.Version=v${version}" # Doesn't work currently: https://github.com/carlmjohnson/versioninfo/discussions/12
    "-X github.com/carlmjohnson/versioninfo.Revision=v${version}"
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

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    mainProgram = "k0sctl";
    maintainers = with maintainers; [
      nickcao
      qjoly
    ];
  };
}
