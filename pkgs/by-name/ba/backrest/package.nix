{
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  restic,
  util-linux,
  stdenv,
}:
let
  pname = "backrest";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "garethgeorge";
    repo = "backrest";
    rev = "refs/tags/v${version}";
    hash = "sha256-qxEZkRKkwKZ+EZ3y3aGcX2ioKOz19SRdi3+9mjF1LpE=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${pname}-webui";
    src = "${src}/webui";

    npmDepsHash = "sha256-mS8G3+JuASaOkAYi+vgWztrSIIu7vfaasu+YeRJjWZw=";

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist/* $out
      runHook postInstall
    '';
  };
in
buildGoModule {
  inherit pname src version;

  vendorHash = "sha256-YukcHnXa/QimfX3nDtQI6yfPkEK9j5SPXOPIT++eWsU=";

  preBuild = ''
    mkdir -p ./webui/dist
    cp -r ${frontend}/* ./webui/dist
  '';

  nativeCheckInputs = [ util-linux ];

  checkFlags =
    let
      skippedTests =
        [
          "TestServeIndex" # Fails with handler returned wrong content encoding
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          "TestBackup" # relies on ionice
        ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  preCheck = ''
    # Use restic from nixpkgs, otherwise download fails in sandbox
    export BACKREST_RESTIC_COMMAND="${restic}/bin/restic"
    export HOME=$(pwd)
  '';

  meta = {
    description = "Web UI and orchestrator for restic backup";
    homepage = "https://github.com/garethgeorge/backrest";
    changelog = "https://github.com/garethgeorge/backrest/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ interdependence ];
    mainProgram = "backrest";
    platforms = lib.platforms.unix;
  };
}
