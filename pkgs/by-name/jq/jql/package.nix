{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "8.0.6";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    rev = "jql-v${version}";
    hash = "sha256-bb3QoODsVZaTw5mcagvcGLn8uwG48nmHPgtlIC2ZdVE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7+qlQf44DgjijKlM+HRjyubH3W/PJbortri3ur0ASnk=";

  meta = with lib; {
    description = "JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      akshgpt7
      figsoda
    ];
    mainProgram = "jql";
  };
}
