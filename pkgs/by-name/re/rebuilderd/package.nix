{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  sqlite,
  xz,
  zstd,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "rebuilderd";
  version = "0.20.0-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "rebuilderd";
    rev = "455997a529b239d1c2bec51bf648cff132f84fe0";
    hash = "sha256-0hbh+QV91tJiJnOktDlo+IkmNUeBwE82QtY4fcJ5lR0=";
  };

  cargoHash = "sha256-gyF8DIxOA3TLy3MCy1CVEqL1oQTSrbVVYWBFfU57Y4U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      bzip2
      openssl
      sqlite
      xz
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  checkFlags = [
    # Failing tests
    "--skip=decompress::tests::decompress_bzip2_compression"
    "--skip=decompress::tests::decompress_gzip_compression"
    "--skip=decompress::tests::decompress_xz_compression"
    "--skip=decompress::tests::decompress_zstd_compression"
    "--skip=decompress::tests::detect_bzip2_compression"
    "--skip=decompress::tests::detect_gzip_compression"
    "--skip=decompress::tests::detect_xz_compression"
    "--skip=decompress::tests::detect_zstd_compression"
    "--skip=proc::tests::hello_world"
    "--skip=proc::tests::size_limit_kill"
    "--skip=proc::tests::size_limit_no_kill"
    "--skip=proc::tests::size_limit_no_kill_but_timeout"
    "--skip=proc::tests::timeout"
  ];

  meta = {
    description = "Independent verification of binary packages - reproducible builds";
    homepage = "https://github.com/kpcyrd/rebuilderd";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rebuilderd";
  };
}
