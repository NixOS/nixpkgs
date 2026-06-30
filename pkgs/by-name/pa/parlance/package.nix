{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "parlance";
  version = "0-unstable-2025-11-03";

  src = fetchFromGitHub {
    owner = "buyukakyuz";
    repo = "parlance";
    rev = "8ed03f66780db63b04657e4a09b632c2b0ed8467";
    hash = "sha256-n6gvHXXG2R2bqiHNmJN+YOkE57PlOFq2mKN+xHdOpbE=";
  };

  cargoHash = "sha256-fxB0PF04Pikyl2/XTPdLGTGJqfy4brjXA9KSq9eiQ6k=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Peer-to-peer messaging for LANs with UDP multicast discovery and TCP messaging";
    homepage = "https://github.com/buyukakyuz/parlance";
    license = lib.licenses.unfree; # https://github.com/buyukakyuz/parlance/issues/1
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "parlance";
  };
}
