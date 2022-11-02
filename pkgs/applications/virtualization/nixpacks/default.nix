{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9b1j3hY4ChlLIXmNsIjt6SjqHOYSqdY98amV36WPU74=";
  };

  cargoSha256 = "sha256-s34mYMaHElBTD7I6QZtGsVTZUbVkcSmavvLs2k4mJDw=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
