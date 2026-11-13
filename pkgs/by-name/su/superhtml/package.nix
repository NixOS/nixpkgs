{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_17,
}:
let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "superhtml";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "superhtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m1a6lQ4UrXNHzAd8LTl9X53O1gEu4boYClrzCgmNV5w=";
  };

  nativeBuildInputs = [
    zig
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gmdqWaedz0qAuPY/kocOo3btKWVE5KedVmSCML4jCBk=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
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
