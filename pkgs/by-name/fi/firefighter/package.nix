{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "firefighter";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "esr";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-C3Q/3RipUFfVpMV0Zk9LbTHIqt39zDT3iR9Aspk3Tfc=";
  };

  cargoHash = "sha256-rQjVS2VLbE8hQzIqqFpiYtUiGAwL4Gh3WbAKGyGFGBM=";

  meta = {
    description = "Save the houses and trees from a raging, wind-driven forest fire!";
    homepage = "https://gitlab.com/esr/firefighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ tdback ];
  };
})
