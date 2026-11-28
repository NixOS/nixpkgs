{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  cmake,
  cairo,
  hyprutils,
  hyprwayland-scanner,
  libGL,
  libjpeg,
  libxkbcommon,
  pango,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxdmcp,
  debug ? false,
}:
gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpicker" + lib.optionalString debug "-debug";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpicker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oFZ7DUtYYVsrK2Wb5BG2Dg7cn/MfXAfdMNStHEML23Q=";
  };

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  dontStrip = debug;
  separateDebugInfo = !debug;

  nativeBuildInputs = [
    cmake
    hyprwayland-scanner
    pkg-config
  ];

  buildInputs = [
    cairo
    hyprutils
    libGL
    libjpeg
    libxkbcommon
    pango
    wayland
    wayland-protocols
    wayland-scanner
    libxdmcp
  ];

  postInstall = ''
    mkdir -p $out/share/licenses
    install -Dm644 $src/LICENSE -t $out/share/licenses/hyprpicker
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wlroots-compatible Wayland color picker that does not suck";
    homepage = "https://github.com/hyprwm/hyprpicker";
    changelog = "https://github.com/hyprwm/hyprpicker/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = wayland.meta.platforms;
    mainProgram = "hyprpicker";
  };
})
