{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, meson
, ninja
, pkg-config
, wayland-scanner
, freetype
, libglvnd
, libxkbcommon
, wayland
, wayland-protocols
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sov";
  version = "0.94";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "sov";
    rev = finalAttrs.version;
    hash = "sha256-JgLah21ye3G9jE3UTZu8r+nanwBDIQXmqv9iP1C+aUw=";
  };

  patches = [
    # mark wayland-scanner as build-time dependency
    # https://github.com/milgra/sov/pull/45
    (fetchpatch2 {
      url = "https://github.com/milgra/sov/commit/8677dcfc47e440157388a8f15bdda9419d84db04.patch";
      hash = "sha256-P1k1zosHcVO7hyhD1JWbj07h7pQ7ybgDHfoufBinEys=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    freetype
    libglvnd
    libxkbcommon
    wayland
    wayland-protocols
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Workspace overview app for sway";
    homepage = "https://github.com/milgra/sov";
    license = lib.licenses.gpl3Only;
    mainProgram = "sov";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
