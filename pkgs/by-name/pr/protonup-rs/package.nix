{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "auyer";
    repo = "Protonup-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wD0R1aVYcLwTg21k3fHu+asTjYq9vI0X9GzyVg5yAvw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6FQDpL74h13eughrB+ZDnWQ3zb2XDRwe/TtOYY4PK9I=";

  # Requires internet access
  doCheck = false;

  meta = {
    mainProgram = "protonup-rs";
    description = "Rust app to install and update GE-Proton for Steam, and Wine-GE for Lutris";
    homepage = "https://github.com/auyer/Protonup-rs";
    changelog = "https://github.com/auyer/Protonup-rs/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      joshprk
    ];
  };
})
