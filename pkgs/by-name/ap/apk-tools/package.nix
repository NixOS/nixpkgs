{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  python3,
  cmocka,
  scdoc,
  openssl,
  zlib,
  zstd,
  luaSupport ? stdenv.hostPlatform == stdenv.buildPlatform,
  lua5_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apk-tools";
  version = "3.0.9";

  src = fetchFromGitLab {
    domain = "gitlab.alpinelinux.org";
    owner = "alpine";
    repo = "apk-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EyavcILJkbW8o/nv3EcK+V9FuKyD/mIX6lWQvnATieg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals luaSupport [
    lua5_3
    lua5_3.pkgs.lua-zlib
  ];

  buildInputs = [
    openssl
    zlib
    zstd
    scdoc
    cmocka
  ]
  ++ lib.optional luaSupport lua5_3;

  strictDeps = true;

  mesonFlags = [
    (lib.mesonEnable "lua" luaSupport)
    (lib.mesonOption "lua_bin" "lua")
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://gitlab.alpinelinux.org/alpine/apk-tools";
    description = "Alpine Package Keeper";
    maintainers = [ ];
    license = lib.licenses.gpl2Only;
    mainProgram = "apk";
  };
})
