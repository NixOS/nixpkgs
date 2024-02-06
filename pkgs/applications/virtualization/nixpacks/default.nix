{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S7Kgp1KNp8GTGp+Go7pUdRJTZLxFsOYfmgcaRBQfeHA=";
  };

  cargoHash = "sha256-5Q5ZUSPI+BQj/2nIx6RsshJQPPoZO4EX07b1rzvXlyU=";

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
