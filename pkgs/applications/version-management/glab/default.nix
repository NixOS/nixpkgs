{ lib, buildGoModule, fetchFromGitLab, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "glab";
  version = "1.28.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-e3tblY/lf25TJrsLeQdaPcgVlsaEimkjQxO0P9X1o6w=";
  };

  vendorHash = "sha256-PH0PJujdRtnVS0s6wWtS6kffQBQduqb2KJYru9ePatw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    # failed to read configuration:  mkdir /homeless-shelter: permission denied
    export HOME=$TMPDIR
  '';

  subPackages = [ "cmd/glab" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)
  '';

  meta = with lib; {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    maintainers = with maintainers; [ freezeboy ];
  };
}
