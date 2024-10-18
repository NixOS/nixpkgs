{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  copywrite,
}:

buildGoModule rec {
  pname = "copywrite";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "copywrite";
    rev = "6ed520a710166c6094098b786c63f212604654a4"; # matches tag release
    hash = "sha256-DmlPioaw/wMk8GoBYNG24P4J1C6h0bjVjjOuMYW6Tgo=";
  };

  vendorHash = "sha256-ZIu0/fue3xi+YVE9GFsVjCNs8t3c3TWH8O0xUzJdim8=";

  shortRev = builtins.substring 0 7 src.rev;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/copywrite/cmd.version=${version}"
    "-X github.com/hashicorp/copywrite/cmd.commit=${shortRev}"
  ];

  CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/copywrite completion bash > copywrite.bash
    $out/bin/copywrite completion zsh > copywrite.zsh
    $out/bin/copywrite completion fish > copywrite.fish
    installShellCompletion copywrite.{bash,zsh,fish}
  '';

  passthru.tests.version = testers.testVersion {
    package = copywrite;
    command = "copywrite --version";
    version = "${version}-${shortRev}";
  };

  meta = {
    description = "Automate copyright headers and license files at scale";
    mainProgram = "copywrite";
    homepage = "https://github.com/hashicorp/copywrite";
    changelog = "https://github.com/hashicorp/copywrite/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dvcorreia ];
  };
}
