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
  version = "1.11";

  outputs = [
    "out"
    "sqlite"
  ];

  src = fetchFromBitbucket {
    owner = "alekseyt";
    repo = "nunicode";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-6255YdX7eYSAj0EAE4RgX1m4XDNIF/Nc4ZCvXzTxpag=";
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

  nativeBuildInputs = [
    cmake
    sqlite
  ];

  # avoid name-clash on case-insensitive filesystems
  cmakeBuildDir = "build-dir";

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    (
    echo running SQLite testsuite

    cd sqlite3
    RESULT=$(../../sqlite3/testsuite < ../../sqlite3/tests.sql | sqlite3)
    grep <<<$RESULT FAILED && echo SQLite testsuite failed && false

    echo SQLite testsuite succeeded
    )

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, small and portable Unicode library with SQLite extension";
    homepage = "https://bitbucket.org/alekseyt/nunicode";
    changelog = "https://bitbucket.org/alekseyt/nunicode/src/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
    platforms = lib.platforms.unix;
  };
})
