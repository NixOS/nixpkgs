{
  lib,
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
  perl,
}:

buildGoModule rec {
  pname = "ssh-tools";
  version = "1.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "vaporup";
    repo = "ssh-tools";
    rev = "v${version}";
    hash = "sha256-ZMjpc2zjvuLJES5ixEHvo7oAx1JGzy60LzN09Ykn/54=";
  };

  vendorHash = "sha256-GSFhz3cIRl4XUA18HUeUkrw+AJyOkU3ZrZKYTGsWbug=";

  subPackages = [
    "cmd/go/ssh-authorized-keys"
    "cmd/go/ssh-sig"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ perl ];

  postInstall = ''
    install cmd/{bash,perl}/ssh-*/ssh-* -t $out/bin
    installManPage man/*.1
  '';

  meta = with lib; {
    description = "Making SSH more convenient";
    homepage = "https://codeberg.org/vaporup/ssh-tools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
