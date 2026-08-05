{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,
  crate ? "cli",
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genealogos-${crate}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "genealogos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7DD3anpFpQD4RMOUyuJZtbSi/U4Kb78v0FnfwUEFTOU=";
    # Genealogos' fixture tests contain valid nix store paths, and are thus incompatible with a fixed-output-derivation.
    # To avoid this, we just remove the tests
    postFetch = ''
      rm -r $out/genealogos/tests/
    '';
  };

  cargoHash = "sha256-VPtj26ShMERqCMCKT6dTNp4rwQDqFVP8zO0rUSeqgrQ=";

  cargoBuildFlags = [
    "-p"
    "genealogos-${crate}"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Since most tests were removed, just skip testing
  doCheck = false;

  meta = {
    description = "Nix sbom generator";
    homepage = "https://github.com/tweag/genealogos";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erin ];
    changelog = "https://github.com/tweag/genealogos/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram =
      {
        api = "genealogos-api";
        cli = "genealogos";
      }
      .${crate};
    platforms = lib.platforms.unix;
  };
})
