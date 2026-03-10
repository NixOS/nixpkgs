{
  lib,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:
let
  pname = "sql-studio";
  version = "0.1.50";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    tag = version;
    hash = "sha256-sXlOnqzi3N+56sdJdkpcVq1mKgdhhu0KdU1Xdoyr10w=";
  };

  ui = buildNpmPackage {
    pname = "sql-studio-ui";
    inherit version src;
    npmDepsHash = "sha256-4mDe8b5J1wrHz7OCClkE5WTbtfs3TMZB/vhiVuaHiyQ=";
    sourceRoot = "${src.name}/ui";
    installPhase = ''
      runHook preInstall

      cp -pr --reflink=auto -- dist "$out/"

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-+hf0GtD5lfa//JYFQZFvO+2m9FgOn9jV6NQ0rQejRXg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  preBuild = ''
    cp -pr --reflink=auto -- ${ui} ui/dist
  '';

  passthru = {
    inherit ui;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "ui"
      ];
    };
  };

  meta = {
    description = "SQL Database Explorer [SQLite, libSQL, PostgreSQL, MySQL/MariaDB, ClickHouse, Microsoft SQL Server]";
    homepage = "https://github.com/frectonz/sql-studio";
    mainProgram = "sql-studio";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frectonz ];
    platforms = lib.platforms.all;
  };
}
