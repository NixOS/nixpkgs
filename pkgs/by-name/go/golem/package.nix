{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  writeShellScriptBin,

  # nativeBuildInputs
  pkg-config,
  protobuf,

  # buildInputs
  fontconfig,
  openssl,

  redis,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "golem";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "golemcloud";
    repo = "golem";
    tag = "v${version}";
    hash = "sha256-6a+OTIKDuo9ievCypGV/3jg4dNqMIHAC/EwYVTAaLUg=";
  };

  # Taker from https://github.com/golemcloud/golem/blob/v1.0.26/Makefile.toml#L399
  postPatch = ''
    grep -rl --include 'Cargo.toml' '0\.0\.0' | xargs sed -i "s/0\.0\.0/${version}/g"
  '';

  # shadow_rs (used by golem-common) shells out to `git describe` during
  # build.rs execution. The unpacked archive has no .git directory, so
  # provide a stub `git` that returns the current tag.
  gitStub = writeShellScriptBin "git" ''
    case "$1" in
      describe) echo "v${version}"; exit 0 ;;
    esac
    exec /bin/git "$@"
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    gitStub
  ];

  buildInputs = [
    fontconfig
    (lib.getDev openssl)
  ];

  cargoHash = "sha256-MmMaeRA+4W78UBtj0G3UW2IgLJW1R5FrrvyGqU/YoCc=";

  # Tests are failing in the sandbox because of some redis integration tests
  doCheck = false;
  checkInputs = [ redis ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = [ "${placeholder "out"}/bin/golem-cli" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source durable computing platform that makes it easy to build and deploy highly reliable distributed systems";
    changelog = "https://github.com/golemcloud/golem/releases/tag/${src.tag}";
    homepage = "https://www.golem.cloud/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmatasfp ];
    mainProgram = "golem-cli";
  };
}
