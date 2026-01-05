{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "catbox";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "konimarti";
    repo = "catbox";
    tag = "v${version}";
    hash = "sha256-mLjrHDc8Sn/cHYc8VbrC0YMVVCKyhiYHVzE5kvMergc=";
  };

  vendorHash = "sha256-mbxZUCxkPhgIzUUgiQ1P1z6Zgs0UaVnm+erW60AIIH8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pipe mbox messages into shell commands";
    homepage = "https://github.com/konimarti/catbox";
    license = lib.licenses.mit;
    mainProgram = "catbox";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
