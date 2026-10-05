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
  version = "1.8.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-+qtNX5zxMQSugCxxCdgTABfOlTQ3KUTbAr4xKahGkO4=";
  };

  cargoHash = "sha256-o5SEeEcMYSdMbDVGeSiVyp4S6eRQkuTAn9FURAJa3LU=";

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
