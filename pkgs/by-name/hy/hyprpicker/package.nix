{
  lib,
  stdenv,
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
  libXdmcp,
  debug ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpicker" + lib.optionalString debug "-debug";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CWmzXhsdk+c1d7Ub7TXQ2BVYla1HSJ9jbgOilbVl1so=";
  };

  cmakeBuildType = if debug then "Debug" else "Release";

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
    libXdmcp
  ];

  postInstall = ''
    mkdir -p $out/share/licenses
    install -Dm644 $src/LICENSE -t $out/share/licenses/hyprpicker
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wlroots-compatible Wayland color picker that does not suck";
    homepage = "https://github.com/hyprwm/hyprpicker";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.hyprland.members;
    platforms = wayland.meta.platforms;
    mainProgram = "hyprpicker";
  };
})
