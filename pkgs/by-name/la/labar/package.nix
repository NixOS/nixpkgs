{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,

  # buildInputs
  cairo,
  librsvg,
  alsa-lib,
  gtk4,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "labar";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Amodio";
    repo = "${finalAttrs.pname}";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eXizGL7etaBBp8gO2FCruDqbMh+jpUlPrYbzhSJEJh0=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    librsvg
    alsa-lib
    gtk4
    wayland
    wayland-protocols
  ];

  mesonBuildType = "release";

  mesonFlags = [
    "-Db_sanitize=none"
  ];

  meta = {
    homepage = "https://github.com/Amodio/labar";
    description = "Launch bar for Wayland";
    license = lib.licenses.gpl3Plus;
    mainProgram = "${finalAttrs.pname}";
    inherit (wayland.meta) platforms;
    maintainers = with lib.maintainers; [ amodio ];
  };
})
