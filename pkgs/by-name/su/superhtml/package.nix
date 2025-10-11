{
  lib,
  callPackage,
  fetchFromGitHub,
  stdenv,
  zig_0_15,
}:
let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "superhtml";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "superhtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jwyhTD3QP017W6sjWhujeSo0C/kPRKyaJqSiSWIsqdc=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "HTML Language Server and Templating Language Library";
    homepage = "https://github.com/kristoff-it/superhtml";
    license = lib.licenses.mit;
    mainProgram = "superhtml";
    maintainers = with lib.maintainers; [ petertriho ];
    platforms = lib.platforms.unix;
  };
})
