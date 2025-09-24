{
  lib,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  pname = "sql-studio";
  version = "0.1.35";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    rev = version;
    hash = "sha256-ZWGV4DYf+85LIGVDc8hcWSEJsM6UisuCB2Wd2kiw/sk=";
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

  cargoHash = "sha256-rWG5iPXiG7kCf0yLAqcQi8AM3qv/WTUiY4cVrjpUc/Y=";

  preBuild = ''
    cp -pr --reflink=auto -- ${ui} ui/dist
  '';

  meta = {
    description = "SQL Database Explorer [SQLite, libSQL, PostgreSQL, MySQL/MariaDB, ClickHouse, Microsoft SQL Server]";
    homepage = "https://github.com/frectonz/sql-studio";
    mainProgram = "sql-studio";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frectonz ];
    platforms = lib.platforms.all;
  };
}
