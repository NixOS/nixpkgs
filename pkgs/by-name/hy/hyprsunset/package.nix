{
  lib,
  gcc16Stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  hyprland-protocols,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  wayland,
  wayland-protocols,
  wayland-scanner,
  nix-update-script,
}:
gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprsunset";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprsunset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MhrVi5f6n9eJv8kcDngb8j2P5F3i5/GCR77+qIWnjf4=";
  };

  postPatch = ''
    # hyprwayland-scanner is not required at runtime
    substituteInPlace CMakeLists.txt --replace-fail "hyprwayland-scanner>=0.4.0" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
  ];

  buildInputs = [
    hyprland-protocols
    hyprlang
    hyprutils
    wayland
    wayland-protocols
    wayland-scanner
  ];

  strictDeps = true;

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprsunset";
    changelog = "https://github.com/hyprwm/hyprsunset/releases/tag/${finalAttrs.src.tag}";
    description = "Application to enable a blue-light filter on Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.hyprland ];
    maintainers = with lib.maintainers; [ logger ];
    mainProgram = "hyprsunset";
  };
})
