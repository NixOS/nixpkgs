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
  version = "0.1.45";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    tag = version;
    hash = "sha256-LAPJPYHCIBRrnz03s3VhFaVfmGAoIj1UrsY+u2/FaRQ=";
  };

  ui = buildNpmPackage {
    pname = "sql-studio-ui";
    inherit version src;
    npmDepsHash = "sha256-RVVCmlfembWI+MLxt+96V2Xmczkscuw79aNPWtYlGG8=";
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

  cargoHash = "sha256-Dtstp9xEWGau+OJ6471gCEC5eWneiPj03pBMxYBr7DI=";

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
