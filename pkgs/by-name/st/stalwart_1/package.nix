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
  withBundledWebui ? true,
  withBundledSpamFilter ? false,
}:
let
  rocksdb = rocksdb_11_8;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart" + (lib.optionalString stalwartEnterprise "-enterprise");
  version = "1.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "stalwart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qspkVWx2myrPzctMRrPse3m1tniRe5L7+cAOr8avML8=";
  };

  cargoHash = "sha256-Wdqv6GAsQZNlt6xdiM/iEyP8WBYK26z0d3fA7iedVoU=";

  # use static web interface and spam filter rules
  postPatch =
    lib.optionalString withBundledWebui ''
      substituteInPlace crates/common/src/manager/defaults.rs \
        --replace-fail \
          '"https://github.com/stalwartlabs/webui/releases/download/v2/webui.zip"' \
          '"file://${finalAttrs.passthru.webui}/webui.zip"'
    ''
    + lib.optionalString withBundledSpamFilter ''
      substituteInPlace crates/registry/src/schema/structs_impl.rs \
        --replace-fail \
          '"https://github.com/stalwartlabs/spam-filter/releases/latest/download/spam-filter-rules.json.gz"' \
          '"file://${finalAttrs.passthru.spam-filter}/spam-filter-rules.json.gz"'
    '';

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
    "keep"
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
      (nix-update-script { attrPath = "stalwart_1.webui"; })
      (nix-update-script { attrPath = "stalwart_1.spam-filter"; })
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
