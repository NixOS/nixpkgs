{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "license-generator";
  version = "1.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jp7NQfDh512oThZbLj0NbqcH7rxV2R0kDv1wsiTNf/M=";
  };

  cargoHash = "sha256-GP1Xr+M7mDXFB1fVdTq3VPPQR9QU43iQlJNW9MqcLB0=";

  meta = with lib; {
    description = "Command-line tool for generating license files";
    homepage = "https://github.com/azu/license-generator";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
    mainProgram = "license-generator";
  };
}
