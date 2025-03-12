{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-t9eC7WdPGROLW+j/2O4rV2n16hA9/+rHHyB8E5LLUnE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-496hDZQorc5lnbg07Wps1I9dtxwxq5EGH4hly5tfUQ8=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
    mainProgram = "nixpacks";
  };
}
