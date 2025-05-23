{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-psp";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "overdrivenpotato";
    repo = "rust-psp";
    tag = "v0.3.12"; # rust-psp version, NOT cargo-psp version
    hash = "sha256-O3Bfl/w9gM7lhguIY0/4yVNMeSOdklb2aiuPnvmjG5U=";
  };

  sourceRoot = "${finalAttrs.src.name}/cargo-psp";
  cargoHash = "sha256-oL2KbhpqvPhtN7hpAuR6a383pPKlW1XuXkoew0ZvPUo=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/cargo-psp" \
      --prefix PATH : "$out/bin"
  '';

  meta = {
    description = "Cargo build wrapper for creating Sony PSP executables";
    homepage = "https://github.com/overdrivenpotato/rust-psp/tree/master/cargo-psp";
    changelog = "https://github.com/overdrivenpotato/rust-psp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "cargo-psp";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
  };
})
