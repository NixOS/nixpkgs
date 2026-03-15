{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  pkg-config,
  writableTmpDirAsHomeHook,
  glfw,
  freetype,
  fontconfig,
  libGL,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
}:

let
  zig-toml = fetchFromGitHub {
    owner = "lepton9";
    repo = "zig-toml";
    rev = "8a9b79dde56ac1fc38960ed9c482efb9ff88a6a8";
    hash = "sha256-LAE/l049Bvh3VKT7XrTYEdj+Ekg3JWO2op37ec58sFU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "attyx";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "semos-labs";
    repo = "attyx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q0q+v1urbu/pa1MlCNa6hSOqKRpgrGk/tiCcagCzR90=";
  };

  nativeBuildInputs = [
    zig
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    glfw
    freetype
    fontconfig
    libGL
    libx11
    libxcursor
    libxrandr
    libxi
  ];

  dontConfigure = true;
  dontInstall = true;
  dontCheck = true;

  buildPhase = ''
    runHook preBuild
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"

    # Set up the Zig package cache with pre-fetched dependency
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"
    cp -r ${zig-toml} "$ZIG_GLOBAL_CACHE_DIR/p/toml-0.3.2-YDcxkrdYAQB8b9k1q_sp51jt2ymgGLmOX_BD4kQi53Eo"

    zig build -Doptimize=ReleaseSafe --prefix $out --color off
    runHook postBuild
  '';

  meta = {
    description = "Fast GPU-accelerated terminal emulator built with Zig";
    homepage = "https://github.com/semos-labs/attyx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "attyx";
    platforms = lib.platforms.linux;
  };
})
