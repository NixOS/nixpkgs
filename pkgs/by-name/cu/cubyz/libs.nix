{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
}:

let
  zig_hook = callPackage ./zighook.nix { };
in

stdenv.mkDerivation (finalAttrs: {
  version = "10";
  pname = "cubyz-libs";
  src = fetchFromGitHub {
    owner = "pixelguys";
    repo = "cubyz-libs";
    tag = finalAttrs.version;
    hash = "sha256-fGuTKV+B7lbyPUQ1BViz11QEwRuWV9x3H+96vk5IW9E=";
  };

  postConfigure = ''
    ln -s ${callPackage ./libsdeps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_hook
  ];

  zigBuildFlags = [
    "-Dtarget=native-linux-musl"
    "-Doptimize=ReleaseSafe"
  ];

  meta = {
    homepage = "https://github.com/PixelGuys/Cubyz-libs";
    description = "Contains libraries used in Cubyz";
    platforms = lib.platforms.linux;
    mainProgram = "cubyz";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
})
