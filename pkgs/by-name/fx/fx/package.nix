{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "fx";
  version = "36.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-wUiyMczToGqfHZ/FMUhCO4ud6h/bNHhVt4eWoZJckbU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-8KiCj2khO0zxsZDG1YD0EjsoZSY4q+IXC+NLeeXgVj4=";

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
