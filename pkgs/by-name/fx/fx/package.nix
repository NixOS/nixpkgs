{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fx";
  version = "35.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-EirlA/gcW77UP9I4pVCjjG3pSYnCPw+idX9YS1izEpY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-h9BUL7b8rNmhVxmXL3CBF39WSkX+8eS2M9NDJhbPI0o=";

  postInstall = ''
    installShellCompletion --cmd fx \
      --bash <($out/bin/fx --comp bash) \
      --fish <($out/bin/fx --comp fish) \
      --zsh <($out/bin/fx --comp zsh)
  '';

  meta = with lib; {
    description = "Terminal JSON viewer";
    mainProgram = "fx";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
