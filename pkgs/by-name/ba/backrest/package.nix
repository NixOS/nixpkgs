{
  buildGoModule,
  fetchFromGitHub,
  gzip,
  iana-etc,
  lib,
  libredirect,
  nodejs,
  pnpm_9,
  restic,
  stdenv,
  util-linux,
  makeBinaryWrapper,
}:
let
  pname = "backrest";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "garethgeorge";
    repo = "backrest";
    tag = "v${version}";
    hash = "sha256-8WWs7XEVKAc/XmeL+dsw25azfLjUbHKp2MsB6Be14VE=";
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
      fetcherVersion = 1;
      hash = "sha256-vJgsU0OXyAKjUJsPOyIY8o3zfNW1BUZ5IL814wmJr3o=";
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

  vendorHash = "sha256-cYqK/sddLI38K9bzCpnomcZOYbSRDBOEru4Y26rBLFw=";

  nativeBuildInputs = [
    gzip
    makeBinaryWrapper
  ];

  preBuild = ''
    mkdir -p ./webui/dist
    cp -r ${frontend}/* ./webui/dist

    go generate -skip="npm" ./...
  '';

  nativeCheckInputs = [
    util-linux
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  checkFlags =
    let
      skippedTests = [
        "TestMultihostIndexSnapshots"
        "TestRunCommand"
        "TestSnapshot"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestBackup" # relies on ionice
        "TestCancelBackup"
        "TestFirstRun" # e2e test requires networking
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  preCheck = ''
    # Use restic from nixpkgs, otherwise download fails in sandbox
    export BACKREST_RESTIC_COMMAND="${restic}/bin/restic"
    export HOME=$(pwd)
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/backrest \
      --set-default BACKREST_RESTIC_COMMAND "${lib.getExe restic}"
  '';

  meta = {
    description = "Web UI and orchestrator for restic backup";
    homepage = "https://github.com/garethgeorge/backrest";
    changelog = "https://github.com/garethgeorge/backrest/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "backrest";
    platforms = lib.platforms.unix;
  };
}
