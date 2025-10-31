{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "smug";
  version = "0.3.11";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ivaaaan";
    repo = "smug";
    rev = "v${version}";
    sha256 = "sha256-NUnabx71q/yrkGsdYa9qruyTLjk/sJBvV7bzoKn+eLo=";
  };

  vendorHash = "sha256-N6btfKjhJ0MkXAL4enyNfnJk8vUeUDCRus5Fb7hNtug=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  postInstall = ''
    installManPage ./man/man1/smug.1
    installShellCompletion completion/smug.{bash,fish}
  '';

  meta = with lib; {
    homepage = "https://github.com/ivaaaan/smug";
    description = "tmux session manager";
    license = licenses.mit;
    maintainers = with maintainers; [ juboba ];
    mainProgram = "smug";
  };
}
