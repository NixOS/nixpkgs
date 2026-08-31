{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "infrarust";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "Shadowner";
    repo = "Infrarust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ntHWteA1UDpXJc7HfRAmLN3lLz2Tn+u6n53vJDv7IRQ=";
  };

  cargoHash = "sha256-a210tGEkDpleXrjtGv9YU/z/2K5Q9Tj80aMfUK4fbdA=";
  enableParallelBuilding = true;

  meta = {
    description = "High-Performance Minecraft Reverse Proxy in Rust";
    homepage = "https://github.com/shadowner/infrarust";
    changelog = "https://github.com/Shadowner/Infrarust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ hustlerone ];
  };
})
