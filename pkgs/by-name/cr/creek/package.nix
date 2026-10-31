{
  callPackage,
  lib,
  zig_0_16,
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
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "creek";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "nmeum";
    repo = "creek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-573tuXZLbn/A/IQGbu26Tw3jShpahNeeFz5UMz72+WE=";
  };

  patches = [
    ./0000-consume-status-line-delimiter-and-reset-the-status-buffer.patch
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    zig
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
