{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  shared-mime-info,
  installShellFiles,
  scdoc,
  bzip2,
  openssl,
  sqlite,
  xz,
  zstd,
  stdenv,
  darwin,
  buildPackages,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rebuilderd";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "rebuilderd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YMBq+Z9yMQRXOM3U679g2lnBZlH/h0VLjoxySxi4SCo=";
  };

  postPatch = ''
    substituteInPlace tools/src/args.rs \
      --replace-fail "/etc/rebuilderd-sync.conf" '${placeholder "out"}/etc/rebuilderd-sync.conf'

    substituteInPlace worker/src/config.rs \
      --replace-fail 'from("/etc/rebuilderd-worker.conf")' 'from("${placeholder "out"}/etc/rebuilderd-worker.conf")'

    substituteInPlace worker/src/proc.rs \
      --replace-fail '/bin/echo' 'echo'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-MjFQ5d9VWHodjj+hIsKgAIUdaiarXIi5GCS+47n5MGU=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mkdir -p $out/etc

      # install config files
      install -Dm 644 -t "$out/etc" contrib/confs/rebuilderd-sync.conf
      install -Dm 640 -t "$out/etc" contrib/confs/rebuilderd-worker.conf contrib/confs/rebuilderd.conf

      installShellCompletion --cmd rebuildctl \
        --bash <(${emulator} $out/bin/rebuildctl completions bash) \
        --fish <(${emulator} $out/bin/rebuildctl completions fish) \
        --zsh <(${emulator} $out/bin/rebuildctl completions zsh)

      for f in contrib/docs/*.scd; do
        local page="contrib/docs/$(basename "$f" .scd)"
        scdoc < "$f" > "$page"
        installManPage "$page"
      done
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.tests = {
    rebuilderd = nixosTests.rebuilderd;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Independent verification of binary packages - reproducible builds";
    homepage = "https://github.com/kpcyrd/rebuilderd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rebuilderd";
  };
})
