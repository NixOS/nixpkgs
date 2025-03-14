{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${version}";
    hash = "sha256-pCCyGFAeeRV9OV6bp5KIUb8/ZD7mktBR0pV+bB14AZc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/Q92s2I/JG745Nd2ZewKx4P/SMdyhXIMsR4oa7TImm8=";

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
