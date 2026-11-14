{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "nixpeek";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "voidhartt";
    repo = "NixPeek";
    rev = "v0.1.0";
    hash = "sha256-fNfxBlOtKj8mz0zR3h0dHZ0YQBq9czEjSk2Ge2j9zN8=";
  };

  vendorHash = "sha256-ecodI5ImNp1bkpNcUDKnKK/uUzJwOQ+u2lTz6eq7kM4=";

  __structuredAttrs = true;

  subPackages = [ "cmd/nixpeek" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Terminal UI for searching Nix packages with attrPath-first workflow";
    homepage = "https://github.com/voidhartt/NixPeek";
    license = lib.licenses.mit;
    mainProgram = "nixpeek";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ voidhartt ];
  };
}
