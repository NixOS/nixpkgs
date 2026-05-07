{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "cerca";
  version = "0-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "cblgh";
    repo = "cerca";
    rev = "722c38d96160ccf69dd7a8122b62660102b64a59";
    hash = "sha256-M5INnik/TIzH0Afi8/6/PnhwsAhd+kFaDHejfsmuhn0=";
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
