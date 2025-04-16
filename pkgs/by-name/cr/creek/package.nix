{
  callPackage,
  lib,
  zig_0_13,
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
  zig = zig_0_13;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "creek";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "nmeum";
    repo = "creek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Q690DEMgPqURTHKzJwH5iVyTLvgYqNpxuwAEV+/Lyw=";
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
    homepage = "https://git.8pit.net/creek";
    changelog = "https://github.com/nmeum/creek/releases/v${finalAttrs.version}";
    description = "Malleable and minimalist status bar for the River compositor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexandrutocar ];
    mainProgram = "creek";
    platforms = lib.platforms.linux;
  };
})
