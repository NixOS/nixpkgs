{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Hy2QRGuXSidUrJ7kb1AhkaLeaevhhleGE8QvnNZf/L0=";
  };

  cargoSha256 = "sha256-5EJGUi74hrd3vifJ3r2vO0Qq2YEt0stXSi+RAGTme2I=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
