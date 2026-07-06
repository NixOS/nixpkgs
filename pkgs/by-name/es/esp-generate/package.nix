{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "esp-generate";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aD+FID/YRTsJ0PY5CLpwO0NDg2izNiWEPGKVbKdFy+8=";
  };

  cargoHash = "sha256-I3Yr81Txxp+gnBsP2OY1MWfYZo6O3Okg2YFUfhK8IJo=";

  meta = {
    description = "Template generation tool to create no_std applications targeting Espressif's chips";
    homepage = "https://github.com/esp-rs/esp-generate";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.eymeric ];
  };
})
