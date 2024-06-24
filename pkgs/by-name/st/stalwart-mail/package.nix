{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, protobuf
, bzip2
, openssl
, sqlite
, zstd
, stdenv
, darwin
, nix-update-script
, nixosTests
, rocksdb_8_11
}:

let
  # Stalwart depends on rocksdb crate:
  # https://github.com/stalwartlabs/mail-server/blob/v0.8.0/crates/store/Cargo.toml#L10
  # which expects a specific rocksdb versions:
  # https://github.com/rust-rocksdb/rust-rocksdb/blob/v0.22.0/librocksdb-sys/Cargo.toml#L3
  # See upstream issue for rocksdb 9.X support
  # https://github.com/stalwartlabs/mail-server/issues/407
  rocksdb = rocksdb_8_11;
  version = "0.8.2";
in
rustPlatform.buildRustPackage {
  pname = "stalwart-mail";
  inherit version;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "mail-server";
    rev = "v${version}";
    hash = "sha256-JzbfQ/WZrHGdG9vv9ngfTxqwBxS+ZezIIp8yUJ2VplE=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-w40mksUVMBXSr/LBXj0uyZ/VbvJFMFJaQN5Kx6sLm5I=";

  patches = [
    # Remove "PermissionsStartOnly" from systemd service files,
    # which is deprecated and conflicts with our module's ExecPreStart.
    # Upstream PR: https://github.com/stalwartlabs/mail-server/pull/528
    (fetchpatch {
      url = "https://github.com/stalwartlabs/mail-server/pull/528/commits/6e292b3d7994441e58e367b87967c9a277bce490.patch";
      hash = "sha256-j/Li4bYNE7IppxG3FGfljra70/rHyhRvDgOkZOlhMHY=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    openssl
    sqlite
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  };

  postInstall = ''
    mkdir -p $out/etc/stalwart
    cp resources/config/spamfilter.toml $out/etc/stalwart/spamfilter.toml
    cp -r resources/config/spamfilter $out/etc/stalwart/

    mkdir -p $out/lib/systemd/system

    substitute resources/systemd/stalwart-mail.service $out/lib/systemd/system/stalwart-mail.service \
      --replace "__PATH__" "$out"
  '';

  # Tests require reading to /etc/resolv.conf
  doCheck = false;

  passthru = {
    update-script = nix-update-script { };
    tests.stalwart-mail = nixosTests.stalwart-mail;
  };

  meta = with lib; {
    description = "Secure & Modern All-in-One Mail Server (IMAP, JMAP, SMTP)";
    homepage = "https://github.com/stalwartlabs/mail-server";
    changelog = "https://github.com/stalwartlabs/mail-server/blob/${version}/CHANGELOG";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada onny ];
  };
}
