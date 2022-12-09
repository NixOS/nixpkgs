{ lib
, buildGoModule
, fetchFromGitHub
, go-mockery
, installShellFiles
}:

buildGoModule rec {
  pname = "git-team";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "hekmekk";
    repo = "git-team";
    rev = "v${version}";
    hash = "sha256-LZR30zqwit/xydQbpGm1LXd/tno/sTCaftgjVkVS6ZY=";
  };

  vendorHash = "sha256-NTOUL1oE2IhgLyYYHwRCMW5yCxIRxUwqkfuhSSBXf6A=";

  nativeBuildInputs = [
    go-mockery
    installShellFiles
  ];

  preBuild = ''
    mockery --dir=src/ --all --keeptree
  '';

  postInstall = ''
    go run main.go --generate-man-page > git-team.1
    installManPage git-team.1

    installShellCompletion --cmd git-team \
      --bash <($out/bin/git-team completion bash) \
      --zsh <($out/bin/git-team completion zsh)
  '';

  meta = with lib; {
    description = "Command line interface for managing and enhancing git commit messages with co-authors";
    homepage = "https://github.com/hekmekk/git-team";
    license = licenses.mit;
    maintainers = with maintainers; [ lockejan ];
  };
}
