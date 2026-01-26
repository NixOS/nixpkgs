{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goda";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${version}";
    hash = "sha256-Cwt2tIP8S+76meuUT/GDUcMGKhJKBg3qGFwen2sEG8I=";
  };

  vendorHash = "sha256-ZDiDAabLUGa/NFs2EQpwWAd8ypxUZ32I8AOeYCm/ntA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/loov/goda";
    description = "Go Dependency Analysis toolkit";
    maintainers = with lib.maintainers; [ michaeladler ];
    license = lib.licenses.mit;
    mainProgram = "goda";
  };
}
