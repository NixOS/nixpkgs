{
  lib,
  fetchCrate,
  rustPlatform,
  makeBinaryWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-psp";
  version = "0.2.10";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-vc3SAFxEUU7nq+DWFnnjFKSAXSUxIuQ3vp/rhU2qChU=";
  };

  cargoHash = "sha256-h1bb7i4B28sFvomyLk51Jl7sAe6obgG6i2HbSM5ERP4=";

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
