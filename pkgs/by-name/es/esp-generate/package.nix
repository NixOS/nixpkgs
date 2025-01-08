{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
    hash = "sha256-vfHORu0C3vK7a9jv1Wj+XjqM7mR8/t0N4x3hfARdxaw=";
  };

  cargoHash = "sha256-hYgEZvRXXhgzuNuSu4ytrlWDwlVYX6R46agu+BxrbEo=";

  meta = {
    description = "Template generation tool to create no_std applications targeting Espressif's chips";
    homepage = "https://github.com/esp-rs/esp-generate";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.eymeric ];
  };
}
