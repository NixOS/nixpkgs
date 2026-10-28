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
  version = "0.1.53";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    tag = version;
    hash = "sha256-8QUXe3ooaeFoW175OGSutI93iqH5L+7aerq+tmxgwa8=";
  };

  ui = buildNpmPackage {
    pname = "sql-studio-ui";
    inherit version src;
    npmDepsHash = "sha256-2maxrXiRBnKG7OZKmo1Xx4EY49FV+F8PEqAUu2Jtw/E=";
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

  cargoHash = "sha256-hg2OqIY4fRK4BLjuJXxn0h6+VtLS5/bZhVDSUQoVRjo=";

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
