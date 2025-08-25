{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "hydrasect";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "blitz";
    repo = "hydrasect";
    rev = "4628ae05935595c54dbdd10d7d7b7aaca27d9541";
    hash = "sha256-hsnb4r8qjMt20omspQVnuL1tvMdyTHvUKCXTY2cqzxM=";
  };

  cargoHash = "sha256-VVXQxgJzLTduXjPNKFQxQI4tzpMPb+Gh7VQTuu0aGqs=";

  meta = {
    description = "The tool that makes bisecting nixpkgs pleasant.";
    homepage = "https://github.com/blitz/hydrasect";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "hydrasect";
  };
}
