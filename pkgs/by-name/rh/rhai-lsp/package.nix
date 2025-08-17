{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "rhai-lsp";
  version = "0-unstable-2022-10-25";

  src = fetchFromGitHub {
    owner = "rhaiscript";
    repo = "lsp";
    rev = "2f1fcd73f43b909d1d5e96123516e599b9aaaa88";
    hash = "sha256-cgcOjlCYMMGNnI2uUBubX6xbntTKj5F+C1Yi/GVtSQ4=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    mv $out/bin/{fuzz-parser,rhai-fuzz-parser}
  '';

  meta = {
    description = "Language server for Rhai";
    homepage = "https://github.com/rhaiscript/lsp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lsp";
  };
}
