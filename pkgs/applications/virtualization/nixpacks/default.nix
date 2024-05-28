{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M4RZwcFiupZdePDkUWRTiTNA58siMsggTGpvHb8j88Y=";
  };

  cargoHash = "sha256-hSzDboP2YJoPPzugb0ABiogKU7lauJNML8szThB2zqg=";

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
