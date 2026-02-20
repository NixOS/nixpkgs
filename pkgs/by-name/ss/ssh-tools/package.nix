{
  lib,
  bash,
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
  perl,
}:

buildGoModule (finalAttrs: {
  pname = "ssh-tools";
  version = "1.9";

  src = fetchFromCodeberg {
    owner = "vaporup";
    repo = "ssh-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZMjpc2zjvuLJES5ixEHvo7oAx1JGzy60LzN09Ykn/54=";
  };

  vendorHash = "sha256-GSFhz3cIRl4XUA18HUeUkrw+AJyOkU3ZrZKYTGsWbug=";

  subPackages = [
    "cmd/go/ssh-authorized-keys"
    "cmd/go/ssh-sig"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    bash
    perl
  ];

  postInstall = ''
    install cmd/{bash,perl}/ssh-*/ssh-* -t $out/bin
    installManPage man/*.1
  '';

  meta = {
    description = "Making SSH more convenient";
    homepage = "https://codeberg.org/vaporup/ssh-tools";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
