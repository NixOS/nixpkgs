{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ripsecrets";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "sirwart";
    repo = "ripsecrets";
    rev = "v${version}";
    hash = "sha256-MyFeSEZAG99g1Uh8KVA7CSZZVXUOF2qYJ0o1YviiPp4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-e11kd+W8M8y5rC328Ycf2NB4wPdAQ++RcprrYaoM3t0=";

  meta = with lib; {
    description = "Command-line tool to prevent committing secret keys into your source code";
    homepage = "https://github.com/sirwart/ripsecrets";
    changelog = "https://github.com/sirwart/ripsecrets/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ripsecrets";
  };
}
