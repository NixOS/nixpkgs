{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fontconfig,
  icu,
  libdrm,
  libGL,
  libinput,
  libX11,
  libXcursor,
  libxkbcommon,
  libgbm,
  pixman,
  seatd,
  srm-cuarzo,
  udev,
  wayland,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "louvre";
  version = "2.18.1-1";

  src = fetchFromGitHub {
    owner = "CuarzoSoftware";
    repo = "Louvre";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wkOY3ARq7x3roRflRN8rMSbrI5B4amI+0CVJmfLYx2w=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    substituteInPlace examples/meson.build \
      --replace-fail "/usr/local/share/wayland-sessions" "${placeholder "out"}/share/wayland-sessions"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    icu
    libdrm
    libGL
    libinput
    libX11
    libXcursor
    libxkbcommon
    libgbm
    pixman
    seatd
    srm-cuarzo
    udev
    wayland
    xorgproto
  ];

  outputs = [
    "out"
    "dev"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C++ library for building Wayland compositors";
    homepage = "https://github.com/CuarzoSoftware/Louvre";
    mainProgram = "louvre-views";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
