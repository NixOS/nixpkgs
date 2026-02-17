{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rust-jemalloc-sys-unprefixed,
  sqlite,
  iproute2,
  iptables,
  nix-update-script,
}:
let
  binPath = lib.makeBinPath [
    iproute2
    iptables
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geph5";
  version = "0.2.93";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "geph5";
    rev = "geph5-client-v${finalAttrs.version}";
    hash = "sha256-ZYcGW6Ssauf5BUs75KBV+4Zub2ZCVN29cWTxeNi87cI=";
  };

  cargoHash = "sha256-0Ml8tgWghxhDJzUMMD+YGwy3fyFjKcNjbV8MDJW8rZk=";

  postPatch = ''
    substituteInPlace binaries/geph5-client/src/vpn/*.sh \
      --replace-fail 'PATH=' 'PATH=${binPath}:'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    rust-jemalloc-sys-unprefixed
    sqlite
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
  };

  buildFeatures = [
    "aws_lambda"
    "windivert"
  ];

  checkFlags = [
    # Wrong test
    "--skip=traffcount::tests::test_traffic_count_basic"
    # Requires network
    "--skip=dns::tests::resolve_google"
    "--skip=tests::test_clib"
    # Never finish
    "--skip=tests::test_blind_sign"
    "--skip=tests::test_generate_secret_key"
    "--skip=tests::ping_pong"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "geph5-client-v(.*)"
    ];
  };

  meta = {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    homepage = "https://github.com/geph-official/geph5";
    changelog = "https://github.com/geph-official/geph5/releases/tag/geph5-client-v${finalAttrs.version}";
    mainProgram = "geph5-client";
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
})
