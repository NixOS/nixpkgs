{
  fetchFromGitHub,
  lib,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "intel_fw";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "platform-system-interface";
    repo = "intel_fw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eOJDbRwq4ilbRSmfKfZ95qyUvnPYZrwt+BhGCzij2R8=";
  };
  __structuredAttrs = true;

  cargoHash = "sha256-PLqvgG8qasbuE15EuiDlFaaU6Jm0UnODspCW1OZrE/I=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern Intel Firmware Tool and Library";
    homepage = "https://platform-system-interface.github.io/intel_fw/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      karui
    ];
    platforms = lib.platforms.all;
    mainProgram = "intel_fw";
  };
})
