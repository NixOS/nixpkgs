{
  lib,
  stdenv,
  buildGoModule,
  bash,
  coreutils,
  fd,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeShellScriptBin,
}:

let
  duForTests = writeShellScriptBin "du" ''
    args=()
    while (( $# > 0 )); do
      case "$1" in
        -I)
          shift
          args+=("--exclude=$1")
          ;;
        *)
          args+=("$1")
          ;;
      esac
      shift
    done

    exec ${lib.getExe' coreutils "du"} "''${args[@]}"
  '';
in
buildGoModule (finalAttrs: {
  pname = "mole-cleaner";
  version = "1.58.0";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    tag = "V${finalAttrs.version}";
    hash = "sha256-fk77PqWiRQu1q5c7VFpyS0HdfGhhfuPVOjPjmg2m+Xs=";
  };

  vendorHash = "sha256-iGwtKV6mJfSgZ5rMB5ASXzdKTPBy9RqoysM4JRh0dts=";

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  postPatch = ''
    # The cancellation test stub blocks on `tail`, unreachable at /usr/bin
    # inside the Darwin sandbox. PATH resolves the stdenv coreutils one.
    substituteInPlace cmd/analyze/analyze_test.go \
      --replace-fail '/usr/bin/tail' 'tail'

    substituteInPlace mole \
      --replace-fail '/bin/pwd' 'pwd' \
      --replace-fail 'update_message="$(read_update_message_cache "$msg_cache")"' 'update_message=""'
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

  nativeCheckInputs = [
    duForTests
  ];

  # No usable ps in the build sandbox: /usr/bin is not mounted and nixpkgs'
  # ps (adv_cmds) lacks entitlements, so %mem/rss are empty for foreign
  # processes and exit 1. Upstream CI runs these against the system ps.
  #
  # No /Users in the build sandbox either: account-root protection compares a
  # path's parent against an existing /Users directory, so that assertion
  # cannot hold while sandboxed.
  checkFlags = [
    "-skip=AcceptsCurrentDarwinOutput|CollectProcessesUnderCommaLocale|TestValidateTrashTargetRejectsCriticalRoots"
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
     --prefix PATH : ${
       lib.makeBinPath [
         fd
       ]
     } \
      --run '
        case "$1" in
          update|remove)
            echo "mo $1 is unsupported for Nix-installed Mole; update or remove it through your Nix profile or configuration." >&2
            exit 1
            ;;
        esac
        '

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
