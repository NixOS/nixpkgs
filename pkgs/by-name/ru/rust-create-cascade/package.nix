{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-create-cascade";
  version = "1.0.42";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "crlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G/CrM9jc9EHzv7JL6EF2rMOPsUGxS6EIt8nVbkh1PrQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust-create-cascade";

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    description = "Tool for building CRLite certificate revocation filters";
    homepage = "https://github.com/mozilla/crlite";
    changelog = "https://github.com/mozilla/crlite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "rust-create-cascade";
  };
})
