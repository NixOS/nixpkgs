{
  lib,
  aws-lc,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  nix-update-script,
}:
let
  pname = "sql-studio";
  version = "0.1.54";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    tag = version;
    hash = "sha256-va1YSbbzrqOb1/CrQ9365zPinBI99tfL8xQmJ0EB4O8=";
  };

  ui = buildNpmPackage {
    pname = "sql-studio-ui";
    inherit version src;
    npmDepsHash = "sha256-kGwzNCb2LiPmzzgLYZl62CRGlKCK6BUW1b7Zzf3NT1c=";
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

  cargoHash = "sha256-Cw8Y1cTc9pSRhS/SAIkv5sa0DS3aS23P2PsoJMRoYiM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    openssl
    sqlite
  ];

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
