{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iz/lTm/8Oqmo16lMDxpI2vFFq6BnnG2yeDAgKc8jTFU=";
  };

  cargoHash = "sha256-/V4Zj9yJtl3Fo7vXc0f3J6cp/mSxFG9YJg1r/RoHx/M=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
