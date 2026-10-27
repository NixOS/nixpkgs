{
  lib,
  stdenv,
  fetchFromGitHub,

  catch2,
  cmake,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite-modern-cpp";
  version = "3.2-unstable-2023-12-03";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SqliteModernCpp";
    repo = "sqlite_modern_cpp";
    rev = "6e3009973025e0016d5573529067714201338c80";
    hash = "sha256-DD1EV3rBWe813TEHpa8nCnwHQjUizB5NOx5uGep5tJc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    catch2
    sqlite
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    (lib.cmakeBool "HUNTER_ENABLED" false)
  ];

  doCheck = true;

  dontUseCmakeInstall = true;

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_package(sqlite3 CONFIG REQUIRED)' \
                     'find_package(SQLite3 REQUIRED)' \
      --replace-fail 'sqlite3::sqlite3' 'SQLite::SQLite3'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r $src/hdr/. $out/include/

    runHook postInstall
  '';

  meta = {
    description = "Lightweight C++ wrapper around sqlite3 C api";
    homepage = "https://github.com/SqliteModernCpp/sqlite_modern_cpp";
    # no changelog for unstable version, change to
    # https://github.com/SqliteModernCpp/sqlite_modern_cpp/releases/tag/v${finalAttrs.version}
    # if there are new releases in the future
    changelog = "https://github.com/SqliteModernCpp/sqlite_modern_cpp/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tetov ];
  };
})
