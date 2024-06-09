{
  lib,
  stdenv,
  callPackage,
  fetchFromGitea,

  glbinding,
  assimp,
  qt5,
  xorg,
}:
let
  version = "2.3.1";
in
callPackage (import ./generic.nix {
  pname = "doomsday-engine";
  inherit version;

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "doomsday";
    repo = "engine";
    rev = "v${version}";
    hash = "sha256-7jLL8ho3JL4amSTTu9ICmK1rcXIlJ9XWzh/rE6jT1zI=";
  };

  gamekitPath = "apps/plugins";

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  buildInputs = [
    glbinding
    assimp
    qt5.qtbase
    qt5.qtx11extras
    xorg.libXrandr
    xorg.libXxf86vm
  ];

  # TODO: enable FMOD support by setting FMOD_DIR
  cmakeFlags = [
    (lib.cmakeFeature "DENG_ASSIMP_EMBEDDED" "NO") # Use system assimp
    (lib.cmakeFeature "DE_PREFIX" (placeholder "out")) # Legacy output prefix
  ];

  # Doomsday Engine 2.x depends on QTKit, which has been deprecated a while ago
  # and does not exist on aarch64-darwin
  # See https://github.com/NixOS/nixpkgs/pull/318552#issuecomment-2157550507
  meta.broken = stdenv.isDarwin && stdenv.isAarch64;
}) { }
