{ lib
, buildGoModule
, fetchFromGitHub
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

  vendorSha256 = "sha256-GdwksPmYEGTq/FkG/rvn3o0zMKU1cSkpgZ+GrfVgLWM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    go run main.go --generate-man-page > ${pname}.1
    installManPage ${pname}.1

    # Currently only bash and zsh completions are provided
    installShellCompletion --cmd git-team --bash <($out/bin/git-team completion bash)
    installShellCompletion --cmd git-team --zsh <($out/bin/git-team completion zsh)
  '';

  meta = with lib; {
    description = "Command line interface for managing and enhancing git commit messages with co-authors";
    homepage = "https://github.com/hekmekk/git-team";
    license = licenses.mit;
    maintainers = with maintainers; [ lockejan ];
  };
}
