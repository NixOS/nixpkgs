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

  nativeBuildInputs = [
    zig.hook
    pkg-config
    wayland
    wayland-scanner
  ];

  buildInputs = [
    fcft
    pixman
    wayland-protocols
  ];

  deps = callPackage ./build.zig.zon.nix {
    inherit zig;
  };

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    homepage = "https://git.8pit.net/creek";
    description = "Malleable and minimalist status bar for the River compositor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexandrutocar ];
    mainProgram = "creek";
    platforms = lib.platforms.linux;
  };
})
