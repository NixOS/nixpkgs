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
  makeBinaryWrapper,
}:
let
  pname = "backrest";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "garethgeorge";
    repo = "backrest";
    tag = "v${version}";
    hash = "sha256-lpYny+5bXIxj+ZFhbSn200sBrDShISESZw+L5sy+X+Q=";
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
      hash = "sha256-q7VMQb/FRT953yT2cyGMxUPp8p8XkA9mvqGI7S7Eifg=";
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

  postPatch = ''
    sed -i -e \
      '/func installRestic(targetPath string) error {/a\
        return fmt.Errorf("installing restic from an external source is prohibited by nixpkgs")' \
      internal/resticinstaller/resticinstaller.go
  '';

  vendorHash = "sha256-AINnBkP+e9C/f/C3t6NK+6PYSVB4NON0C71S6SwUXbE=";

  nativeBuildInputs = [
    gzip
    makeBinaryWrapper
  ];

  preBuild = ''
    mkdir -p ./webui/dist
    cp -r ${frontend}/* ./webui/dist

    go generate -skip="npm" ./...
  '';

  nativeCheckInputs = [ util-linux ];

  checkFlags =
    let
      skippedTests =
        [
          "TestMultihostIndexSnapshots"
          "TestRunCommand"
          "TestSnapshot"
        ]
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

  postInstall = ''
    wrapProgram $out/bin/backrest \
      --set-default BACKREST_RESTIC_COMMAND "${lib.getExe restic}"
  '';

  meta = {
    description = "Web UI and orchestrator for restic backup";
    homepage = "https://github.com/garethgeorge/backrest";
    changelog = "https://github.com/garethgeorge/backrest/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "backrest";
    platforms = lib.platforms.unix;
  };
}
