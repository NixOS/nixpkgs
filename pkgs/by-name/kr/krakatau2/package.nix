{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  src = fetchFromGitHub {
    owner = "Storyyeller";
    repo = "Krakatau";
    rev = "6da0abc20603fecaaa0e3300ebd97e04f07c2fb6";
    hash = "sha256-4ROx/XAWRzP8NWDYndDMBUXPw+nAu4nH4ukkyzS8eZ8=";
  };
in
rustPlatform.buildRustPackage {
  inherit src;
  pname = "krakatau2";
  version = "0-unstable-2025-02-01";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "zip-0.6.4" = "sha256-x56JHdFdoLNhT/TC9sQQD4Ouu2LZ+D5CrS1mMyFVJBg=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "Java decompiler, assembler, and disassembler";
    license = lib.licenses.gpl3Only;
    mainProgram = "krak2";
    maintainers = with lib.maintainers; [
      rhendric
    ];
  };
}
