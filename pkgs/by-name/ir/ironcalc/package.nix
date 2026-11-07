{
  lib,
  callPackage,
  fetchFromGitHub,

  rustPlatform,

  pkg-config,
  python3,
  python3Packages,
  bzip2,
  zstd,
  stdenv,

  coreutils,
  sqlite,
  writeShellApplication,
  symlinkJoin,
}:

let
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ironcalc";
    repo = "ironcalc";
    tag = "v${version}";
    hash = "sha256-uC1ovWBYXwWxaBh85hDSuKPfrx7Kr5gqvbgnc3hwfWA=";
  };

  cargoHash = "sha256-eeyKsKFb4XyCHph3cT4mTj2d3ymM83N8QHRZYFBnjrk=";

  meta = {
    description = "Open source selfhosted spreadsheet engine";
    homepage = "https://github.com/ironcalc/IronCalc";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "ironcalc";
    maintainers = with lib.maintainers; [ phanirithvij ];
    teams = with lib.teams; [ ngi ];
  };

  server = rustPlatform.buildRustPackage {
    pname = "ironcalc-server";
    inherit src version;

    buildAndTestSubdir = "webapp/app.ironcalc.com/server";
    cargoRoot = "webapp/app.ironcalc.com/server";

    cargoHash = "sha256-bd1EGOzxpNNdms1F7mEXnC9avn85aVGa3Rcxy+U7+GY=";

    __structuredAttrs = true;

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      bzip2
      zstd
    ];

    postInstall = ''
      install -Dm644 webapp/app.ironcalc.com/server/init_db.sql $out/share/ironcalc/init_db.sql
    '';

    meta = meta // {
      description = "IronCalc server package";
      mainProgram = "ironcalc_server";
    };
  };

  wasm = callPackage ./frontend/wasm.nix { };
  workbook = callPackage ./frontend/workbook.nix { };
  frontend = callPackage ./frontend/frontend.nix { };

  tools = rustPlatform.buildRustPackage {
    pname = "ironcalc-tools";
    inherit src version;
    inherit cargoHash;

    cargoBuildFlags = [
      "--package"
      "ironcalc"
    ];
    cargoTestFlags = [
      "--package"
      "ironcalc"
      "--package"
      "ironcalc_base"
    ];

    patches = [
      # nix specific issue, can't reproduce without nix, not upstreaming
      ./0001-FIX-test-message.patch
    ];

    __structuredAttrs = true;

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      bzip2
      zstd
    ];

    doCheck = true;

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      { $out/bin/xlsx_2_icalc 2>&1 || true; } | grep -q "Usage:"

      $out/bin/xlsx_2_icalc xlsx/tests/docs/CHOOSE.xlsx test.ic
      test -f test.ic
      runHook postInstallCheck
    '';

    meta = meta // {
      description = "IronCalc helper tools";
      mainProgram = "xlsx_2_icalc";
    };
  };

  wrapper = writeShellApplication {
    name = "ironcalc";

    runtimeInputs = [
      coreutils
      sqlite
      server
    ];

    text = ''
      IRONCALC_DB_PATH="''${IRONCALC_DB_PATH:-ironcalc.sqlite}"
      mkdir -p "$(dirname "$IRONCALC_DB_PATH")"

      if [ ! -f "$IRONCALC_DB_PATH" ]; then
        echo "Initializing database..."
        sqlite3 "$IRONCALC_DB_PATH" < "${server}/share/ironcalc/init_db.sql"
      fi

      export ROCKET_DATABASES="{ironcalc={url=\"$IRONCALC_DB_PATH\"}}"
      export IRONCALC_WEBAPP_DIR="''${IRONCALC_WEBAPP_DIR:-${frontend}}"

      exec ironcalc_server "$@"
    '';
  };

  python = python3Packages.ironcalc;
  nodejs = callPackage ./nodejs.nix { };
in
symlinkJoin {
  pname = "ironcalc";
  inherit version;
  paths = [
    tools
    wrapper
  ];

  __structuredAttrs = true;
  strictDeps = true;

  passthru =
    let
      exports = {
        inherit
          frontend
          workbook
          server
          tools
          wasm
          nodejs
          python
          wrapper
          ;
        widget = workbook; # alias
      };
    in
    {
      inherit
        src
        cargoHash
        ;
      updateScript = [ ./update.sh ];
      tests = exports;
    }
    // exports;

  inherit meta;
}
