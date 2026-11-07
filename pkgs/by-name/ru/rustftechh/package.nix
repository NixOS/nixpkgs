{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustftechh";
  version = "0.1.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-9gnfvRGw0FHnn8L2Q6vM6wMAYec6xcrR+MzcqI0ZAuw=";
  };

  cargoHash = "sha256-HI0RhTn0GvjVq/pof2ZICOnwJgtYr0SKac+i55M2ptc=";

  meta = {
    description = "Blazingly fast system information fetch tool written in Rust";
    homepage = "https://github.com/zackmsa777-a11y/rustfetch";
    changelog = "https://github.com/zackmsa777-a11y/rustfetch/blob/master/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "rustfetch";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ zackmsa777-a11y ];
  };
})
