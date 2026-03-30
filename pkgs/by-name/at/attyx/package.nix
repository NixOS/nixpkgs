{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,

  pkg-config,
  zig,

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
  version = "0.2.47";

  src = fetchFromGitHub {
    owner = "semos-labs";
    repo = "attyx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fREiPiBTzzJtFEPWOISiZ/BI5lZmPyn80oAXohEEGig=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    zig
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
