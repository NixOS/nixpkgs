{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tiAz8nrUq47AgafoXx/6KNl7Q3y1/Z4ITOtznU3hQAw=";
  };

  cargoSha256 = "sha256-6o254VH5fwtcTFPEFfPdLQOLk8YGbEi9ZeDfdHhVCn0=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
