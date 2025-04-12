{
  lib,
  stdenv,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  pname = "sql-studio";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    rev = version;
    hash = "sha256-PDNTOzzoJ3a/OljnZux9ttts/ntwep2rC01IxIfMU1k=";
  };

  ui = buildNpmPackage {
    inherit version src;
    pname = "${pname}-ui";
    npmDepsHash = "sha256-NCq8RuaC+dO6Zbgl1ucJxhJrVZ69Va3b2/gYn4fThAw=";
    sourceRoot = "${src.name}/ui";
    installPhase = ''
      cp -pr --reflink=auto -- dist "$out/"
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-Hw7VbcU/Y8wl4KObHvQfUXRORlbsuLHTQDMzk3Qel20=";

  preBuild = ''
    cp -pr --reflink=auto -- ${ui} ui/dist
  '';

  meta = {
    description = "SQL Database Explorer [SQLite, libSQL, PostgreSQL, MySQL/MariaDB, DuckDB, ClickHouse]";
    homepage = "https://github.com/frectonz/sql-studio";
    mainProgram = "sql-studio";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frectonz ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
