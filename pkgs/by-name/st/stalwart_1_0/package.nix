{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  openssl,
  sqlite,
  foundationdb,
  zstd,
  stdenv,
  _experimental-update-script-combinators,
  nix-update-script,
  rocksdb,
  callPackage,
  withFoundationdb ? false,
  stalwartEnterprise ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart" + (lib.optionalString stalwartEnterprise "-enterprise");
  version = "1.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "stalwart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VU6mvWoeJxisMHspjhZ2fbWUaIHHZORtlaLZVQk68fQ=";
  };

  cargoHash = "sha256-oKLi8VdB2bnDPNwIgM3kZz8HcUKvyE7N38SxIKjlVxI=";

  env = {
    # Prefer system over vendor libraries to make it easier to patch/fix security vulnerabilities
    OPENSSL_NO_VENDOR = true;
    OPENSSL_DIR = lib.getDev openssl;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";

    ZSTD_SYS_USE_PKG_CONFIG = true;
  }
  //
    lib.optionalAttrs
      (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isArmv7))
      {
        # Required to fix Stalwart on ARM systems with 16 KB page size.
        # Using rust-jemalloc-sys causes segmentation faults on x86_64.
        JEMALLOC_SYS_WITH_LG_PAGE = 16;
      };

  depsBuildBuild = [
    pkg-config
    zstd
  ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    openssl
    sqlite
    zstd
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withFoundationdb) [ foundationdb ];

  # Issue: https://github.com/stalwartlabs/stalwart/issues/1104
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "sqlite"
    "postgres"
    "mysql"
    "rocks"
    "s3"
    "redis"
    "azure"
    "nats"
  ]
  ++ lib.optionals withFoundationdb [ "foundationdb" ]
  ++ lib.optionals stalwartEnterprise [ "enterprise" ];

  cargoBuildFlags = [
    "-p"
    "stalwart"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # Since 0.16.27 -> 1.0.0, tests have been deleted from upstream and only accessible in a private repository [1].
  # Therefore, removing all code related to setting up test infra to clean up module, and disable doCheck.
  #  [1] https://stalw.art/blog/protecting-stalwart/
  doCheck = false;

  postInstall = ''
    mkdir -p $out/etc/stalwart

    mkdir -p $out/lib/systemd/system

    substitute resources/systemd/stalwart-mail.service $out/lib/systemd/system/stalwart.service \
      --replace-fail "__PATH__" "$out"
  '';

  passthru = {
    inherit rocksdb; # make used rocksdb version available (e.g., for backup scripts)
    webui = callPackage ./webui.nix { };
    spam-filter = callPackage ./spam-filter.nix { };
    # subpackages have distinct version numbers, so we can't use nix-update's `--subpackage`
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (nix-update-script { attrPath = "stalwart_1_0.webui"; })
      (nix-update-script { attrPath = "stalwart_1_0.spam-filter"; })
    ];
  };

  meta = {
    description = "Secure, modern, all-in-one mail and collaboration server";
    longDescription = ''
      Secure, scalable and fluent in every protocol (IMAP, JMAP, SMTP, CalDAV, CardDAV, WebDAV).
    '';
    homepage = "https://github.com/stalwartlabs/stalwart";
    changelog = "https://github.com/stalwartlabs/stalwart/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = [
      lib.licenses.agpl3Only
    ]
    ++ lib.optionals stalwartEnterprise [
      lib.licenses.stalwart
    ];
    maxSilent = 14400; # 4 hours
    mainProgram = "stalwart";
    maintainers = with lib.maintainers; [
      happysalada
      onny
      oddlama
      pandapip1
      norpol
      debtquity
    ];
  };
})
