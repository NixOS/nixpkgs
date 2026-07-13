{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
  fd,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeShellScript,
}:

let
  duForTests = writeShellScript "mole-cleaner-du-for-tests" ''
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
  version = "1.46.0";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    tag = "V${finalAttrs.version}";
    hash = "sha256-rIoVXEz4K0RFb1ir1gRCyDw5euNwQvLS0GwBsJhuApE=";
  };

  vendorHash = "sha256-hLFlAy4AE1eNOxd4d75Mbo3ZKlwvNK7QV2DNVPd7NHc=";

  subPackages = [
    "cmd/analyze"
    "cmd/status"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
    coreutils
    gawk
  ];

  postInstall = ''
    install -Dm755 mole $out/libexec/mole/mole
    cp -r bin lib $out/libexec/mole/

    mv $out/bin/analyze $out/libexec/mole/bin/analyze-go
    mv $out/bin/status $out/libexec/mole/bin/status-go

    patchShebangs $out/libexec/mole

    mkdir -p $out/libexec/mole/nix-bin
    ln -s ${lib.getExe' coreutils "timeout"} $out/libexec/mole/nix-bin/timeout

    makeWrapper $out/libexec/mole/mole $out/bin/mo \
      --run '
        case "$1" in
          update|remove)
            echo "mo $1 is unsupported for Nix-installed Mole; update or remove it through your Nix profile or configuration." >&2
            exit 1
            ;;
        esac
      ' \
      --prefix PATH : ${
        lib.makeBinPath [
          fd
        ]
      }:$out/libexec/mole/nix-bin:/usr/bin:/bin
  '';

  checkPhase = ''
    runHook preCheck
    mkdir -p "$TMPDIR/mole-test-bin"
    ln -s ${duForTests} "$TMPDIR/mole-test-bin/du"
    PATH="$TMPDIR/mole-test-bin:$PATH" go test ./...
    runHook postCheck
  '';

  doInstallCheck = true;
  versionCheckKeepEnvironment = [
    "HOME"
    "PATH"
  ];
  versionCheckProgram = "${placeholder "out"}/bin/mo";
  versionCheckProgramArg = "--version";
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/mo --help > /dev/null
    test -w "$HOME"
    test ! -e $out/bin/mole
    runHook postInstallCheck
  '';

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
