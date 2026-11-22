{
  lib,
  stdenv,
  buildGoModule,
  bash,
  darwin,
  fd,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "mole-cleaner";
  version = "1.74.0";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    tag = "V${finalAttrs.version}";
    hash = "sha256-Ve0/LOW/AY414QJB/ENApMdesSR4VfQ8R3l/pXHBQwE=";
  };

  vendorHash = "sha256-OQ7QTSuulopAS+2Jet2roZVGPMXgJUav73du+MJlt6o=";

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  postPatch = ''
    # The cancellation test stub blocks on `tail`, unreachable at /usr/bin
    # inside the Darwin sandbox. PATH resolves the stdenv coreutils one.
    substituteInPlace cmd/analyze/analyze_test.go \
      --replace-fail '/usr/bin/tail' 'tail'

    # Use packaged BSD du only in the tests. The installed analyzer
    # must continue using macOS /usr/bin/du, independently of PATH.
    substituteInPlace cmd/analyze/oplog_test.go \
      --replace-fail 'func TestMain(m *testing.M) {' \
        'func TestMain(m *testing.M) { duBinary = "${lib.getExe' darwin.file_cmds "du"}";'
    substituteInPlace cmd/analyze/scanner_test.go \
      --replace-fail '/usr/bin/du' '${lib.getExe' darwin.file_cmds "du"}'

    substituteInPlace mole --replace-fail '/bin/pwd' 'pwd'
  '';

  buildInputs = [
    bash
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [
    "-skip=${
      lib.concatStringsSep "|" [
        # No usable ps in the build sandbox: /usr/bin is not mounted and
        # nixpkgs' ps (adv_cmds) lacks entitlements, so %mem/rss are empty for
        # foreign processes and exit 1. Upstream CI runs these against the
        # system ps.
        "AcceptsCurrentDarwinOutput"
        "CollectProcessesUnderCommaLocale"

        # No /Users in the build sandbox either: account-root protection
        # compares a path's parent against an existing /Users directory, so
        # that assertion cannot hold while sandboxed.
        "TestValidateTrashTargetRejectsCriticalRoots"

        # Only the binary plist subtest requires macOS plutil.
        "^TestSimulatorMetadataXMLAndBinary$/^binary=true$"
      ]
    }"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 mole $out/libexec/mole/mole
    cp -r bin lib $out/libexec/mole/

    install -Dm755 $GOPATH/bin/analyze $out/libexec/mole/bin/analyze-go
    install -Dm755 $GOPATH/bin/status $out/libexec/mole/bin/status-go

    makeWrapper $out/libexec/mole/mole $out/bin/mo \
     --prefix PATH : '/bin' \
     --prefix PATH : '/usr/bin' \
     --prefix PATH : ${lib.makeBinPath [ fd ]}

    runHook postInstall
  '';

  postFixup = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mo \
      --bash <($out/bin/mo completion bash) \
      --fish <($out/bin/mo completion fish) \
      --zsh <($out/bin/mo completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  versionCheckKeepEnvironment = "HOME PATH";
  versionCheckProgram = "${placeholder "out"}/bin/mo";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^V(.*)$" ];
  };

  meta = {
    description = "CLI tool for cleaning and optimizing macOS systems";
    homepage = "https://github.com/tw93/Mole";
    changelog = "https://github.com/tw93/Mole/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ IanHollow ];
    mainProgram = "mo";
    platforms = lib.platforms.darwin;
  };
})
