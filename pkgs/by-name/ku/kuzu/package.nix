{
  lib,
  stdenv,
  cmake,
  ninja,
  python3,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kuzu";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "kuzudb";
    repo = "kuzu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xEhjDAzu742niskkGG3PAWlbhZ476rUmVuwA9I7SDj8=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  meta = {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${finalAttrs.version}";
    description = "Embeddable property graph database management system";
    homepage = "https://kuzudb.com/";
    license = lib.licenses.mit;
    mainProgram = "kuzu";
    maintainers = with lib.maintainers; [ sdht0 ];
    platforms = lib.platforms.all;
  };
})
