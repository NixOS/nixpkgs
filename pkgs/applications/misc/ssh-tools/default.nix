{ lib, buildGoModule, fetchFromGitea, installShellFiles, perl }:

buildGoModule rec {
  pname = "ssh-tools";
  version = "1.8-unstable-2024-03-18";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "vaporup";
    repo = "ssh-tools";
    rev = "69c73844b2498c46f1293b129808bfdce8822c28";
    hash = "sha256-cG75Jn331G0HZZyrE+JWC05f6DgYBz6sx8MTCxsG/vw=";
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
