{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rust-jemalloc-sys-unprefixed,
  sqlite,
  iproute2,
  nftables,
  shadow,
  systemd,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geph5";
  version = "5.9.1";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "gephgui-pkg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GP9kLtC3OrwHIfNena/wLDeWLkLGIOtvE5UpNUiSoco=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/geph5";

  cargoHash = "sha256-5krILNIoc9xtDfSP37xVB+GEegvBGOOPETvMxA9GAVI=";

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace binaries/geph5-app/src/platform.rs \
      --replace-fail 'run_status("systemctl"' 'run_status("${lib.getExe' systemd "systemctl"}"' \
      --replace-fail '"useradd",' '"${lib.getExe' shadow "useradd"}",' \
      --replace-fail '"/usr/sbin/nologin"' '"${shadow}/sbin/nologin"'

    substituteInPlace binaries/geph5-app/src/vpn/linux.rs \
      --replace-fail 'Command::new("nft")' 'Command::new("${lib.getExe nftables}")' \
      --replace-fail 'run("ip"' 'run("${lib.getExe' iproute2 "ip"}"'
  '';

  postInstall = ''
    rm -rf "$out/lib"
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

  __darwinAllowLocalNetworking = true;

  checkFlags = [
    # Need a broker or a peer
    "--skip=china::tests::resolve_baidu_via_alidns"
    "--skip=dns::tests::resolve_google"
    "--skip=tests::test_clib"
    # Never finish
    "--skip=tests::test_blind_sign"
    "--skip=tests::test_generate_secret_key"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=vpn::macos::discovery::tests::live_physical_service_v4"
    "--skip=vpn::macos::discovery::tests::live_primary_v4"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    homepage = "https://geph.io";
    changelog = "https://github.com/geph-official/gephgui-pkg/releases/tag/v${finalAttrs.version}";
    mainProgram = "geph5-client";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
})
