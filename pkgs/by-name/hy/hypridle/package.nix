{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  hyprutils,
  wayland,
  wayland-protocols,
  wayland-scanner,
  hyprlang,
  sdbus-cpp_2,
  systemdLibs,
  nix-update-script,
}:

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hypridle";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    rev = "v${finalAttrs.version}";
    hash = "sha256-esE2L7+9CsmlSjTIHwU9VAhzvsFSMC3kO7EiutCPQpg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    hyprlang
    hyprutils
    sdbus-cpp_2
    systemdLibs
    wayland
    wayland-protocols
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Hyprland's idle daemon";
    homepage = "https://github.com/hyprwm/hypridle";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      iogamaster
      johnrtitor
      khaneliman
    ];
    mainProgram = "hypridle";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
