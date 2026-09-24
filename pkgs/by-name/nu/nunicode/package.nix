{
  lib,
  stdenv,
  fetchFromBitbucket,
  cmake,
  sqlite,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nunicode";
  version = "1.12";

  strictDeps = true;

  __structuredAttrs = true;

  outputs = [
    "out"
    "sqlite"
  ];

  src = fetchFromBitbucket {
    owner = "alekseyt";
    repo = "nunicode";
    tag = finalAttrs.version;
    hash = "sha256-lYGO9WWywh3nJb7yryOnivw9MLYaldmPUr5/Pq5aie8=";
  };

  postPatch = ''
    # load correct SQLite extension on all platforms
    substituteInPlace sqlite3/testsuite --replace-fail \
      "NU='./libnusqlite3.so'" \
      "NU='./libnusqlite3'"

    # fix expressions using like .. escape (https://sqlite.org/lang_expr.html#like)
    substituteInPlace sqlite3/tests.sql --replace-fail '\\' '\'

    # install SQLite extension in a separate output
    echo >>sqlite3/CMakeLists.txt \
      'install(TARGETS nusqlite3 DESTINATION "${placeholder "sqlite"}/lib")'
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ sqlite ];

  nativeCheckInputs = [ sqlite ];

  cmakeFlags = [ (lib.cmakeBool "NU_BUILD_SQLITE3_EXT" true) ];

  doCheck = true;

  checkTarget = "nusqlite3_test";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, small and portable Unicode library with SQLite extension";
    homepage = "https://bitbucket.org/alekseyt/nunicode";
    changelog = "https://bitbucket.org/alekseyt/nunicode/src/${finalAttrs.src.tag}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
    platforms = lib.platforms.unix;
  };
})
