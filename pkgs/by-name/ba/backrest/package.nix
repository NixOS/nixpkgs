{
  buildGoModule,
  fetchFromGitHub,
  gzip,
  lib,
  nodejs,
  pnpm_9,
  restic,
  stdenv,
  util-linux,
}:
let
  pname = "backrest";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "garethgeorge";
    repo = "backrest";
    tag = "v${version}";
    hash = "sha256-X3FiNor2q/JgyV05CIAls7MjMvongH5dGeutPz+CW9I=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "${pname}-webui";
    src = "${src}/webui";

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
    ];

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-rBu+6QwTmQsjHh0yd8QjdHPc3VOmadJQ+NK9X6qbSx8=";
    };

    buildPhase = ''
      runHook preBuild
      export BACKREST_BUILD_VERSION=${version}
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist/* $out
      runHook postInstall
    '';
  });
in
buildGoModule {
  inherit pname src version;

  vendorHash = "sha256-OVJnJ5fdpa1vpYTCxtvRGbnICbfwZeYiCwAS8c4Tg2Y=";

  nativeBuildInputs = [ gzip ];

  preBuild = ''
    mkdir -p ./webui/dist
    cp -r ${frontend}/* ./webui/dist

    go generate -skip="npm" ./...
  '';

  nativeCheckInputs = [ util-linux ];

  checkFlags =
    let
      skippedTests =
        [ "TestRunCommand" ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          "TestBackup" # relies on ionice
          "TestCancelBackup"
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
