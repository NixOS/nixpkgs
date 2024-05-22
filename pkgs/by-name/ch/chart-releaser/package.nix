{ buildGoModule
, coreutils
, fetchFromGitHub
, git
, installShellFiles
, kubernetes-helm
, lib
, makeWrapper
}:

buildGoModule rec {
  pname = "chart-releaser";
  version = "1.6.1";

  # 0102fa30dd78df0d0f8093c4607e6080972ff82d

  src = fetchFromGitHub {
    owner = "helm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8+O9JErEB1Z/zlrWm975v5Qf0YG0lbPcjY5LlDKw8U4=";
  };

  # Don't run tests.
  doCheck = false;

  vendorHash = "sha256-S/V1kTgD/cXaJNYpPPNjM9ya2zv6Bsy/YBn7I/1EjwI=";

  postPatch = ''
    substituteInPlace pkg/config/config.go \
      --replace-fail "/etc/cr" "$out/etc/cr"
  '';

  # https://github.com/helm/chart-releaser/blob/fa01315c4668d4fca627a5afc67409e31b27305c/.goreleaser.yml#L37
  ldflags = [
    "-w"
    "-s"
    "-X github.com/helm/chart-releaser/cr/cmd.Version=${version}"
    "-X github.com/helm/chart-releaser/cr/cmd.GitCommit=${src.rev}"
    "-X github.com/helm/chart-releaser/cr/cmd.BuildDate=19700101-00:00:00"
  ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postInstall = ''
    installShellCompletion --cmd cr \
      --bash <($out/bin/cr completion bash) \
      --zsh <($out/bin/cr completion zsh) \
      --fish <($out/bin/cr completion fish) \

    wrapProgram $out/bin/cr --prefix PATH : ${lib.makeBinPath [
      coreutils
      git
      kubernetes-helm
    ]}
  '';

  meta = with lib; {
    description = "Hosting Helm Charts via GitHub Pages and Releases";
    homepage = "https://github.com/helm/chart-releaser";
    license = licenses.asl20;
    # maintainers = with maintainers; [ atkinschang ];
    mainProgram = "cr";
  };
}
