# Template de submissão ao nixpkgs (layout `by-name`).
#
# Este arquivo NÃO é importado pelo flake deste repositório: ele contém
# `lib.fakeHash` de propósito, para falhar de forma explícita até que o hash da
# fonte real seja calculado.
#
# Preencha com:
#
#   nix-prefetch-github rafael-arkhe arkhe --rev v0.1.0
#
# e substitua `hash` pelo valor SRI retornado.
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arkhe-verify";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rafael-arkhe";
    repo = "arkhe";
    tag = "v${finalAttrs.version}";
    hash = lib.fakeHash; # TODO: substituir pelo hash real
  };

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
    allowBuiltinFetchGit = false;
  };

  cargoBuildFlags = [
    "--locked"
    "-p"
    "arkhe-verify-cli"
    "--bin"
    "arkhe-verify"
  ];

  cargoTestFlags = [ "-p" "arkhe-verify-cli" ];

  SOURCE_DATE_EPOCH = 315532800;

  meta = {
    description = "Offline verifier for Arkhe envelopes, MMR proofs and checkpoints";
    homepage = "https://github.com/rafael-arkhe/nixpkgs-arkhe";
    license = lib.licenses.asl20;
    mainProgram = "arkhe-verify";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
