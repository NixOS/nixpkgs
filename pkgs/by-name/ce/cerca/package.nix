{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "cerca";
  version = "0-unstable-2025-09-16";

  src = fetchFromGitHub {
    owner = "cblgh";
    repo = "cerca";
    rev = "fc5a467d2d6664f5b12c26845700034fffe61f4e";
    hash = "sha256-bGgNV+k8+0Mgp6XwPN/YT5cP1jDXkS/1EfyRWQ64f9c=";
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
