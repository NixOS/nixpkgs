{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayfire,
  wf-config,
  libdrm,
  vulkan-headers,
  libxcb-wm,
  gtkmm3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixdecor";
  version = "0.1.0-unstable-2026-07-13";

  src = fetchFromGitHub {
    owner = "soreau";
    repo = "pixdecor";
    rev = "76a0e8996b41f0df87f0d9c65c816693f1c3fefc";
    hash = "sha256-qYDqPOJBgM/byaJXI851NswtqLcMpGmeekEca5hI1hE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    wayfire
    wf-config
    libdrm
    libxcb-wm
    vulkan-headers
    gtkmm3
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  meta = {
    homepage = "https://github.com/WayfireWM/wayfire-plugins-extra";
    description = "Additional plugins for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wineee ];
    inherit (wayfire.meta) platforms;
  };
})
