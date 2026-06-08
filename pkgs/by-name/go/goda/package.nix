{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goda";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tUt/VxO3QLqPuHleFSO7txiHZ1bJ7ohGak09ZIr/62A=";
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
})
