{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "roughenough";
  version = "2.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "int08h";
    repo = "roughenough";
    tag = finalAttrs.version;
    hash = "sha256-mpCnB0dxb+Jwau28V/pFZ6OuXusNZ6Rvo+4eYpQorwo=";
  };

  cargoHash = "sha256-DxIHrN8MamZ4zq0/cSC2F64cNGQqRoIMt2jZuImlHa4=";

  postInstall = ''
    rm $out/bin/roughenough_integration_test $out/bin/roughenough_load_test
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rugged and performant Roughtime (RFC 10049) server and client";
    homepage = "https://github.com/int08h/roughenough";
    changelog = "https://github.com/int08h/roughenough/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.tomfitzhenry ];
    mainProgram = "roughenough_server";
  };
})
