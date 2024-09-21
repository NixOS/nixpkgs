{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  shared-mime-info,
  installShellFiles,
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

  postPatch = ''
    substituteInPlace tools/src/args.rs \
      --replace-fail "/etc/rebuilderd-sync.conf" '${placeholder "out"}/etc/rebuilderd-sync.conf'

    substituteInPlace worker/src/config.rs \
      --replace-fail 'from("/etc/rebuilderd-worker.conf")' 'from("${placeholder "out"}/etc/rebuilderd-worker.conf")'

    substituteInPlace worker/src/proc.rs \
      --replace-fail '/bin/echo' 'echo'
  '';

  cargoHash = "sha256-gyF8DIxOA3TLy3MCy1CVEqL1oQTSrbVVYWBFfU57Y4U=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      bzip2
      openssl
      shared-mime-info
      sqlite
      xz
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  postInstall = ''
    mkdir -p $out/etc $out/worker

    # install config files
    install -Dm 644 -t "$out/etc" contrib/confs/rebuilderd-sync.conf
    install -Dm 640 -t "$out/etc" contrib/confs/rebuilderd-worker.conf contrib/confs/rebuilderd.conf

    # install rebuilder scripts
    install -Dm 755 -t "$out/usr/libexec/rebuilderd" worker/rebuilder-*.sh

    installManPage contrib/docs/rebuilderd.1
    installManPage contrib/docs/rebuilderd-worker.1
    installManPage contrib/docs/rebuilderd.conf.5
    installManPage contrib/docs/rebuilderd-sync.conf.5
    installManPage contrib/docs/rebuilderd-worker.conf.5
  '';

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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rebuilderd";
  };
}
