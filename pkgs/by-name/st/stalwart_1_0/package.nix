{
  lib,
  stdenv,
  rustPlatform,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  _experimental-update-script-combinators,

  aws-lc,
  bzip2,
  foundationdb,
  pkg-config,
  rocksdb_11_8,
  rust-jemalloc-sys-unprefixed,
  sqlite,
  zstd,

  withFoundationdb ? false,
  stalwartEnterprise ? false,
}:
let
  rocksdb = rocksdb_11_8;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart" + (lib.optionalString stalwartEnterprise "-enterprise");
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "stalwart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/HtAf1QkWz84Zv6vfLOhFVLDsdNlUucchMzDJC/GlE8=";
  };

  cargoHash = "sha256-pbEwTTQm3NpsF8QKz6Q7TBOLC2Pl94HUyioYdTHYBL8=";

  env = {
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  }
  //
    lib.optionalAttrs
      (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isArmv7))
      {
        # Required to fix Stalwart on ARM systems with 16 KB page size.
        JEMALLOC_SYS_WITH_LG_PAGE = 16;
      };

  # for jieba-rs's include-flate proc macro
  depsBuildBuild = [
    pkg-config
    zstd
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    bzip2
    rust-jemalloc-sys-unprefixed
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
