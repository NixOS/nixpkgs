{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  rust-jemalloc-sys-unprefixed,
  sqlite,
  bash,
  coreutils,
  iproute2,
  iptables,
  nix-update-script,
}:
let
  binPath = lib.makeBinPath [
    bash
    coreutils
    iproute2
    iptables
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geph5";
  version = "0.2.102";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "geph5";
    rev = "geph5-client-v${finalAttrs.version}";
    hash = "sha256-E3msw4yG5RxKapHBvhGEVlsJiLgysCgjAtOrJ8fGES0=";
  };

  cargoHash = "sha256-w+1JLxvflb8PQqNi5MnxoEcWctuaC6Ux3oNYJzB6oaE=";

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace binaries/geph5-client/src/vpn/*.sh \
      --replace-fail 'PATH=' 'PATH=${binPath}:'

    substituteInPlace binaries/geph5-client/src/vpn/linux.rs \
      --replace-fail 'Command::new("sh")' 'Command::new("${bash}/bin/sh")' \
      --replace-fail '/usr/bin/env ' '${lib.getExe' coreutils "env"} '
  '';

  postInstall = ''
    rm -rf "$out/lib"
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

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
    # "windivert" # Only on Windows
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Cannot connect to the internet within the macOS sandbox
    "--skip=tests::test_successful_ping"
    "--skip=tests::test_failed_ping"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for program in $out/bin/*; do
      wrapProgram "$program" --prefix PATH : ${binPath}
    done
  '';

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
    platforms = lib.platforms.linux ++ lib.platforms.darwin; # VPN mode is not yet available on macOS.
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
})
