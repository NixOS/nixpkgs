{
  callPackage,
  lib,
  zig_0_14,
  stdenv,
  fetchFromGitHub,
  fcft,
  pixman,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
}:
let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "creek";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "nmeum";
    repo = "creek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5TANQt/VWafm6Lj4dYViiK0IMy/chGr/Gzq0S66HZqI=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    zig.hook
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    fcft
    pixman
    wayland
    wayland-protocols
  ];

  deps = callPackage ./build.zig.zon.nix { };

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/nmeum/creek";
    changelog = "https://github.com/nmeum/creek/releases/v${finalAttrs.version}";
    description = "Malleable and minimalist status bar for the River compositor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexandrutocar ];
    mainProgram = "creek";
    platforms = lib.platforms.linux;
  };
})
