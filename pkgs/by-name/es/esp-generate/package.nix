{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "esp-generate";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JNSz/HRO8qxVaRZLL4qgYF3BIYVkrzyRc3wAWd+dAMo=";
  };

  cargoHash = "sha256-IZH6y7KXdrNO4mxkRPaWi79XQnlrxxaQNG2nahJ8TzY=";

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
