{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  callPackage,
  zig,
  llvmPackages,
  #  pkg-config,
}:
let
  zig_hook =
    (
      (zig.override {
        llvmPackages = llvmPackages;
      }).overrideAttrs
      (oldAttrs: {
        version = "0.16.0";
        src = fetchgit {
          url = "https://codeberg.org/ziglang/zig";
          rev = "d3e20e71be8d94b8c0534d2cb57a1a27c451db9f";
          hash = "sha256-DKOQiB183AuWhkitPclFJqKBi9CTkK6Lccw1vLgF0OQ=";
        };

        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
          llvmPackages.llvm
          llvmPackages.lld
          llvmPackages.clang
        ];
      })
    ).hook.overrideAttrs
      {
        zig_default_flags = "";
      };
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

  postPatch = ''
    ln -s ${callPackage ./libsdeps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_hook
  ];

  zigBuildFlags = [
    #"-j6"				# Included in zig default flags
    #"-Dcpu=baseline" # Included in zig default flags
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
