{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,

  pkg-config,
  zig_0_15,

  fontconfig,
  freetype,
  glfw,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "attyx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "semos-labs";
    repo = "attyx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9OTvpkkIo6pb9G2mvlNeZrwyOwIhAM7f9zy1LJzxJG0=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    zig_0_15
  ];

  buildInputs = [
    fontconfig
    freetype
    glfw
    libGL
    libx11
    libxcursor
    libxi
    libxrandr
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    description = "Fast GPU-accelerated terminal emulator built with Zig";
    homepage = "https://github.com/semos-labs/attyx";
    changelog = "https://github.com/semos-labs/attyx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "attyx";
    platforms = lib.platforms.linux;
  };
})
