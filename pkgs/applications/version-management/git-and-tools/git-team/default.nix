{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "git-team";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "hekmekk";
    repo = "git-team";
    rev = "v${version}";
    sha256 = "0nl5j64b61jw4bkf29y51svjbndmqqrqx96yaip4vjzj2dx9ywm4";
  };

  vendorSha256 = "sha256-xJMWPDuqoNtCCUnKuUvwlYztyrej1uZttC0NsDvYnXI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    go run main.go --generate-man-page > ${pname}.1
    installManPage ${pname}.1

    # Currently only bash completions are provided
    installShellCompletion --cmd git-team --bash <($out/bin/git-team completion bash)
  '';

  meta = with lib; {
    description = "Command line interface for managing and enhancing git commit messages with co-authors";
    homepage = "https://github.com/hekmekk/git-team";
    license = licenses.mit;
    maintainers = with maintainers; [ lockejan ];
  };
}
