{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gu26MSYbTlRLMUpZ9PeYXtqqhzPDQXxEDkjiJgwzIIc=";
  };

  patches = [
    # FIXME: remove in next release
    (fetchpatch2 {
      name = "fix-hypr-wayland-scanner-0.4.4-build.patch";
      url = "https://github.com/hyprwm/hyprpicker/commit/444c40e5e3dc4058a6a762ba5e73ada6d6469055.patch?full_index=1";
      hash = "sha256-tg+oCUHtQkOXDrUY1w1x8zWWO1v4YV8ZxQKuSWuX/AI=";
    })
  ];

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
    maintainers = with lib.maintainers; [
      fufexan
      khaneliman
    ];
    platforms = wayland.meta.platforms;
    mainProgram = "hyprpicker";
  };
})
