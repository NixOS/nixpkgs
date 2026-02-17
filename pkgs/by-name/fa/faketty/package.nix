{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.20";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1AX2DBFOSUcORSQCo/5Vd8puE4hJU9VDfVqxcZDKrrY=";
  };

  cargoHash = "sha256-2MVWtCezrCd+uDAkYLzwDNobrc7TQEu1H2eUHlOcpVE=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = {
    description = "Wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "faketty";
  };
}
