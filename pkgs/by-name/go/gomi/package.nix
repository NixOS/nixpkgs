{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "gomi";
    tag = "v${version}";
    hash = "sha256-FZCvUG6lQH8CFivV/hbIgGQx4FCk1UtreiWXTQVi4+4=";
  };

  vendorHash = "sha256-8aw81DKBmgNsQzgtHCsUkok5e5+LeAC8BUijwKVT/0s=";

  subPackages = [ "." ];

  meta = {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mimame
      ozkutuk
    ];
    mainProgram = "gomi";
  };
}
