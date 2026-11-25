{
  lib,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  writeShellScriptBin,
  callPackage,

  pkg-config,
  protobuf,

  fontconfig,
  libgit2,
  openssl,
  aws-lc,
  sqlite,
  zstd,

  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "golem";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "golemcloud";
    repo = "golem";
    tag = "v${version}";
    hash = "sha256-zmFxRKbLVkzFQx4YoTNPMdi5d/Ekm1H4B993k0HO6Rw=";
  };

  # Manifest pinning the built-in tool plug-in WASMs (bash, python,
  # filesystem-tools, ...), published as a release asset outside the tag.
  # golem-registry-service's build.rs embeds it; the WASMs themselves are
  # downloaded and sha256-verified on first boot.
  builtinArtifactsManifest = fetchurl {
    url = "https://github.com/golemcloud/golem/releases/download/v${version}/builtin-artifacts.release.json";
    hash = "sha256-RMJxM882qurGgLeZuTv0SBXR0eowXGI2ZzXockZm2B4=";
  };

  # Version substitution from upstream's Makefile.toml. Also restore
  # golem-common's implicit mac_address feature, which `dep:mac_address`
  # removes: cargo-auditable's rustc wrapper passes a bare
  # `--features mac_address`, which cargo otherwise rejects, aborting the
  # workspace metadata call that every build script needs.
  postPatch = ''
    grep -rl --include 'Cargo.toml' '0\.0\.0' | xargs sed -i "s/0\.0\.0/${version}/g"
    substituteInPlace golem-common/Cargo.toml \
      --replace-fail '    "dep:mac_address",' '    "mac_address",'
    cp ${builtinArtifactsManifest} builtin-artifacts.release.json
  '';

  # Embed the manifest above, like the official release binaries.
  GOLEM_BUILTIN_RELEASE = "1";

  # shadow_rs runs `git describe` in build.rs; the tarball has no .git.
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
    libgit2
    (lib.getDev openssl)
    aws-lc
    sqlite
    zstd
  ];

  cargoHash = "sha256-2gFNMsXuRqjibgaJM6M04Yx9TOzsrDgj5qdJqUaC1S4=";

  # Unit tests only, like upstream's `unit-tests` task. The rest of the
  # workspace's test suites are integration tests that need Redis, Postgres
  # and built binaries.
  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "golem-schema-derive"
    "--lib"
  ];

  # Compares the embedded manifest with the checked-in fixture that upstream's
  # release tests use; we embed the real release manifest instead.
  checkFlags = [
    "--skip"
    "builtin_artifact_release_defaults_use_verified_cache"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = [ "${placeholder "out"}/bin/golem-cli" ];
  doInstallCheck = true;

  passthru = {
    # nix-update only bumps version, src and cargoHash; the release manifest
    # above needs its hash updated separately.
    updateScript = lib.getExe (callPackage ./update.nix { });
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
