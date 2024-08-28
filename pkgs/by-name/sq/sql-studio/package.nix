{
  lib,
  stdenv,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  pname = "sql-studio";
  version = "0.1.27";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    rev = version;
    hash = "sha256-iSvxdqarHX0AvkMSzL2JFOm32OyMwVKt+Gn7odgwalU=";
  };

  ui = buildNpmPackage {
    inherit version src;
    pname = "${pname}-ui";
    npmDepsHash = "sha256-kGukH0PKF7MtIO5UH+55fddj6Tv2dNLmOC6oytEhP3c=";
    sourceRoot = "${src.name}/ui";
    installPhase = ''
      cp -pr --reflink=auto -- dist "$out/"
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-BlYFbJEDap/k3oi9tFl4JpTyYh8ce7F3NIlOtOid59s=";

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
    broken = stdenv.isDarwin;
  };
}
