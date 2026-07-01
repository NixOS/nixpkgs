### adapted from upstream at <https://github.com/noctalia-dev/noctalia/blob/d967ed5f5484e57866350106be8bfe3b50f90cfd/nix/package.nix> (licensed MIT)
{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libGL,
  libglvnd,
  freetype,
  fontconfig,
  cairo,
  pango,
  harfbuzz,
  libxkbcommon,
  sdbus-cpp_2,
  systemdLibs,
  pipewire,
  pam,
  curl,
  libwebp,
  glib,
  polkit,
  librsvg,
  libqalculate,
  libxml2,
  jemalloc,
  autoAddDriverRunpath,
  cudaSupport ? config.cudaSupport,
}:

stdenv.mkDerivation {
  pname = "noctalia";
  version = "4.7.7-unstable-2026-06-11";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia";
    rev = "7421f80b041e81d6e202a25ade6bfc59d716dd43";
    hash = "sha256-H+uwJBulU/0Qt+BGUvlyrTPgcdOfojSalklpEuKKD2c=";
  };

  postPatch = ''
    # Remove -march=native and -mtune=native for reproducible builds
    substituteInPlace meson.build --replace-fail "'-march=native', '-mtune=native'," ""
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ]
  ++ lib.optional cudaSupport autoAddDriverRunpath;

  buildInputs = [
    wayland
    wayland-protocols
    libGL
    libglvnd
    freetype
    fontconfig
    cairo
    pango
    harfbuzz
    libxkbcommon
    sdbus-cpp_2
    systemdLibs
    pipewire
    pam
    curl
    libwebp
    glib
    polkit
    librsvg
    libqalculate
    libxml2
    jemalloc
  ];

  mesonBuildType = "release";

  ninjaFlags = [ "-v" ];

  meta = {
    description = "Sleek and minimal desktop shell thoughtfully crafted for Wayland";
    homepage = "https://github.com/noctalia-dev/noctalia";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      spacedentist
      kruemmelspalter
      dtomvan
    ];
    mainProgram = "noctalia";
  };
}
