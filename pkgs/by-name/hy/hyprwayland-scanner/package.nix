{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pugixml,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwayland-scanner";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwayland-scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YxmfxHfWed1fosaa7fC1u7XoKp1anEZU+7Lh/ojRKoM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pugixml
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprwayland-scanner";
    description = "A Hyprland version of wayland-scanner in and for C++";
    changelog = "https://github.com/hyprwm/hyprwayland-scanner/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fufexan ];
    mainProgram = "hyprwayland-scanner";
    platforms = lib.platforms.linux;
  };
})
