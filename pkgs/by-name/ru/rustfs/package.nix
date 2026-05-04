{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pkg-config,
  protobuf,
  flatbuffers,
  nodejs_22,
  pnpm_10_29_2,
  pnpmConfigHook,
  openssl,
  systemd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfs";
  version = "1.0.0-beta.4";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = finalAttrs.version;
    hash = "sha256-1GBOq6PUk/FmvgL8otFHBMS+gT5obiGDXnEVYhVbQuw=";
  };

  frontend = stdenv.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-console";
    version = "0.1.7";

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs'.version}";
      hash = "sha256-CBlfNNA4e2zXDCipMvLGWCH+DIH0JUjc+/mp3yjb16I=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs') pname version src;
      pnpm = pnpm_10_29_2;
      fetcherVersion = 3;
      hash = "sha256-CYu8lRRfY9deBgFu4pV59jDWcmqDWndvSHtYX/Y8fkc=";
    };

    nativeBuildInputs = [
      nodejs_22
      pnpmConfigHook
      pnpm_10_29_2
    ];

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r out/. $out/
      runHook postInstall
    '';
  });

  cargoHash = "sha256-RuQb3k/0wm8ginhw/09ZDz22JdoYtDSwsOo07p4n03M=";
  buildAndTestSubdir = "rustfs";

  nativeBuildInputs = [
    flatbuffers
    pkg-config
    protobuf
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemd
  ];

  # Upstream enables Tokio's io-uring feature in the workspace and carries the
  # same flag in .cargo/config.toml; Tokio requires this cfg at compile time.
  env.RUSTFLAGS = "--cfg tokio_unstable";

  # Faulty test-case, remove in next version.
  checkFlags = [
    "--skip=storage::concurrent_get_object_test::tests::test_concurrent_request_tracking"
  ];

  postPatch = ''
    mkdir -p rustfs/static
    cp -r ${finalAttrs.frontend}/. rustfs/static/
  '';

  meta = {
    description = "S3-compatible object storage server written in Rust";
    homepage = "https://github.com/rustfs/rustfs";
    changelog = "https://github.com/rustfs/rustfs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "rustfs";
    platforms = lib.platforms.unix;
  };
})
