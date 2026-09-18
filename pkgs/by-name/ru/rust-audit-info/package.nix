{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-audit-info";
  version = "0.5.4";

  src = fetchCrate {
    pname = "rust-audit-info";
    inherit (finalAttrs) version;
    hash = "sha256-zxdF65/9cgdDLM7HA30NCEZj1S5SogH+oM3aq55K0os=";
  };

  cargoHash = "sha256-ygz9uYwuDI892kwYwJPTsTAkBfsnRN2unOgqv8VHXSA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to extract the dependency trees embedded in binaries by cargo-auditable";
    mainProgram = "rust-audit-info";
    homepage = "https://github.com/rust-secure-code/cargo-auditable/tree/master/rust-audit-info";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
