{
  lib,
  rustPlatform,
  fetchCrate,
  nasm,
  nix-update-script,
  nixos-icons,
  runCommand,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cavif";
  version = "1.6.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-F2b03x+jklgxa3VcRA3y0wuK7AQ2LJtCEvCa6eFeG3w=";
  };

  cargoHash = "sha256-x/0Kgf8oWjL6m2/8ol32EJpKkWSgBRbdCTay6KYrtzg=";

  nativeBuildInputs = [ nasm ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      encode = runCommand "cavif-encode-test" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
        cavif ${nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png -o $out
      '';
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Encoder/converter CLI for AVIF images";
    homepage = "https://github.com/kornelski/cavif-rs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nettika ];
    mainProgram = "cavif";
  };
})
