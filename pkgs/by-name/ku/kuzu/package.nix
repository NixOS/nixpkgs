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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kuzudb";
    repo = "kuzu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3B2E51PluPKl0OucmTPZYEa9BzYoU0Y8G1PQY86ynFA=";
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
    changelog = "https://github.com/kuzudb/kuzu/releases/tag/v${finalAttrs.version}";
    description = "Embeddable property graph database management system";
    homepage = "https://kuzudb.com/";
    license = lib.licenses.mit;
    mainProgram = "kuzu";
    maintainers = with lib.maintainers; [ sdht0 ];
    platforms = lib.platforms.all;
  };
})
