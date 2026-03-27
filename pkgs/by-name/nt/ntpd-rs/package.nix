{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  ntpd-rs,
  installShellFiles,
  pandoc,
  nixosTests,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ntpd-rs";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "pendulum-project";
    repo = "ntpd-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gOt2X/tqtFrmxkTO/8UFwmyX0vPKHsTu+qe5AfqDtMk=";
  };

  cargoHash = "sha256-DXAy/K70sNhVOjDOd6G/juE7JgmewPzGHZDeXAOZ1+s=";

  nativeBuildInputs = [
    pandoc
    installShellFiles
  ];

  __darwinAllowLocalNetworking = true;

  # These fail based on timestamp issues with bundled certificates
  # See https://github.com/NixOS/nixpkgs/issues/497682 & https://github.com/pendulum-project/ntpd-rs/pull/2133
  checkFlags = [
    "--skip=daemon::keyexchange::tests::key_exchange_connection_limiter"
    "--skip=daemon::keyexchange::tests::key_exchange_roundtrip_with_port_server"
    "--skip=daemon::ntp_source::tests::test_deny_stops_poll"
    "--skip=daemon::ntp_source::tests::test_timeroundtrip"
    "--skip=daemon::server::tests::test_server_serves"
    "--skip=nts::tests::test_key_exchange_roundtrip_no_cookies"
    "--skip=nts::tests::test_keyexchange_fixed_key_no_permission"
    "--skip=nts::tests::test_keyexchange_roundtrip_fixed_key"
    "--skip=nts::tests::test_keyexchange_roundtrip_fixed_key_keep_alive"
    "--skip=nts::tests::test_keyexchange_roundtrip_fixed_key_no_permit"
    "--skip=nts::tests::test_keyexchange_roundtrip_no_proto_overlap"
    "--skip=nts::tests::test_keyexchange_roundtrip_no_upgrade_possible"
    "--skip=nts::tests::test_keyexchange_roundtrip_supports"
    "--skip=nts::tests::test_keyexchange_roundtrip_upgrading"
    "--skip=nts::tests::test_keyexchange_roundtrip_v4"
    "--skip=nts::tests::test_keyexchange_roundtrip_v5"
    "--skip=nts::tests::test_keyexchange_supports_no_permission"
  ];

  postPatch = ''
    substituteInPlace utils/generate-man.sh \
      --replace-fail 'utils/pandoc.sh' 'pandoc'
  '';

  postBuild = ''
    source utils/generate-man.sh
  '';

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system docs/examples/conf/{ntpd-rs,ntpd-rs-metrics}.service
    installManPage docs/precompiled/man/{ntp.toml.5,ntp-ctl.8,ntp-daemon.8,ntp-metrics-exporter.8}
  '';

  outputs = [
    "out"
    "man"
  ];

  passthru = {
    tests = {
      nixos = lib.optionalAttrs stdenv.hostPlatform.isLinux nixosTests.ntpd-rs;
      version = testers.testVersion {
        package = ntpd-rs;
        inherit (finalAttrs) version;
      };
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Full-featured implementation of the Network Time Protocol";
    homepage = "https://tweedegolf.nl/en/pendulum";
    changelog = "https://github.com/pendulum-project/ntpd-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      fpletz
      getchoo
    ];
    mainProgram = "ntp-ctl";
    # note: Undefined symbols for architecture x86_64: "_ntp_adjtime"
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
