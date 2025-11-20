{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_14,
}:

let
  zig = zig_0_14;
  zig_hook = zig.hook.overrideAttrs {
    zig_default_flags = "";
  };
in

stdenv.mkDerivation (finalAttrs: {
  version = "8";
  pname = "cubyz-libs";
  src = fetchFromGitHub {
    owner = "pixelguys";
    repo = "cubyz-libs";
    tag = finalAttrs.version;
    hash = "sha256-xg6nk2Oxe7PjT6CbPjDPegcZEn1P36PNc3YKLopb168=";
  };

  postPatch = ''
    ln -s ${callPackage ./libsdeps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_hook
  ];

  zigBuildFlags = [
    #"-j6"				# Included in zig default flags
    "-Dcpu=baseline" # Included in zig default flags
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
