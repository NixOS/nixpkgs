{
  lib,
  rustPlatform,
  rosec,
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rosec-bitwarden-pm";

  inherit (rosec) src version;

  sourceRoot = "${src.name}/rosec-bitwarden-pm";

  cargoHash = "sha256-TAP1G0QJGg3w0lKCUHTsfVvwON7nSlcM4jhtIB+WByQ=";

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Bitwarden (Personal) provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})
