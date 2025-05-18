{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cerca";
  version = "0-unstable-2025-05-06";

  src = fetchFromGitHub {
    owner = "cblgh";
    repo = "cerca";
    rev = "a2706a35e3efc8b816b4374e24493548429041db";
    hash = "sha256-FDlASFjI+D/iOH0r2Yd638aS0na19TxkN7Z1kD/o/fY";
  };

  vendorHash = "sha256-yfsI0nKfzyzmtbS9bSHRaD2pEgxN6gOKAA/FRDxJx40=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Lean forum software";
    homepage = "https://github.com/cblgh/cerca";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "cerca";
  };
}
