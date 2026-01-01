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
<<<<<<< HEAD
  version = "0.1.46";
=======
  version = "0.1.45";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "sql-studio";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-xtW6tF3hc8GyxOMwE6GlZNBNEE/QsKJzyOvAYU6i6M0=";
=======
    hash = "sha256-LAPJPYHCIBRrnz03s3VhFaVfmGAoIj1UrsY+u2/FaRQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ui = buildNpmPackage {
    pname = "sql-studio-ui";
    inherit version src;
<<<<<<< HEAD
    npmDepsHash = "sha256-1k054qLwvpSrWfBKXJRVVomCh1dMSEtjtwUTWCoAaEg=";
=======
    npmDepsHash = "sha256-RVVCmlfembWI+MLxt+96V2Xmczkscuw79aNPWtYlGG8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  cargoHash = "sha256-RMI2pW89PzmxHgZ7ondwNyGE4yeWpf3T6NRNr2eUFjQ=";
=======
  cargoHash = "sha256-Dtstp9xEWGau+OJ6471gCEC5eWneiPj03pBMxYBr7DI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
