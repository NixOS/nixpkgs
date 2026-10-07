{
  lib,
  fetchCrate,
  rustPlatform,
  makeBinaryWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-psp";
  version = "0.2.9";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-zifaXT7Yzo1tG11PrwIIopOul83jBR2Nbdb02l6M0rk=";
  };

  cargoHash = "sha256-M7dBm5a+xAVORvX6sSTZ5JBSNsImi5OTXr+JPFq0DtU=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/cargo-psp" \
      --prefix PATH : "$out/bin"
  '';

  passthru.updateScript = nix-update-script { };

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
