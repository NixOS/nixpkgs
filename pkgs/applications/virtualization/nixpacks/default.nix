{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zxgNHzKXekZnk0OsHw30u4L9U2mIT/MryZuAQ2EBEYg=";
  };

  cargoHash = "sha256-tsGyrU/5yp5PJ2d5HUoaw/jhGgYyDt6qBK+DvC79kmY=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
