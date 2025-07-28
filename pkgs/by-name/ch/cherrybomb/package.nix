{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cherrybomb";
  version = "1.0.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-MHKBP102U1Ug9wZm9x4+opZgG8f6Hx03FvoLV4qaDgY=";
  };

  cargoHash = "sha256-j9CT2HHFY4ANWKvx8t/jgCc3aOiSEJlq8CHstjSc+O4=";

  meta = {
    description = "CLI tool that helps you avoid undefined user behavior by validating your API specifications";
    mainProgram = "cherrybomb";
    homepage = "https://github.com/blst-security/cherrybomb";
    changelog = "https://github.com/blst-security/cherrybomb/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
