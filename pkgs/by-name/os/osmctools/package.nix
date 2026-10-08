{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmctools";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "osm-c-tools";
    repo = "osmctools";
    rev = finalAttrs.version;
    sha256 = "1m8d3r1q1v05pkr8k9czrmb4xjszw6hvgsf3kn9pf0v14gpn4r8f";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  # Fix build with gcc15 (-std=gnu23)
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu17";

  meta = {
    description = "Command line tools for transforming Open Street Map files";
    homepage = [
      "https://wiki.openstreetmap.org/wiki/osmconvert"
      "https://wiki.openstreetmap.org/wiki/osmfilter"
      "https://wiki.openstreetmap.org/wiki/osmupdate"
    ];
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
    license = lib.licenses.agpl3Only;
  };
})
