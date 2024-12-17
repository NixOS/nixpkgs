{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk_11,
  ntpd-rs,
  installShellFiles,
  pandoc,
  nixosTests,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "ntpd-rs";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "pendulum-project";
    repo = "ntpd-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-usLtf4qwKkn+lEYSQWCa1ap9h/52YYMVFDkpFJVD00k=";
  };

  cargoHash = "sha256-ZB18YbCdJpuu7qTXdHgs2IgDCoc3Hs/aDn4dzXmKI8c=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

  nativeBuildInputs = [
    pandoc
    installShellFiles
  ];

  postPatch = ''
    substituteInPlace utils/generate-man.sh \
      --replace-fail 'utils/pandoc.sh' 'pandoc'
  '';

  postBuild = ''
    source utils/generate-man.sh
  '';

  # lots of flaky tests
  doCheck = false;

  checkFlags = [
    # doesn't find the testca
    "--skip=daemon::keyexchange::tests"
  ];

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
        inherit version;
      };
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Full-featured implementation of the Network Time Protocol";
    homepage = "https://tweedegolf.nl/en/pendulum";
    changelog = "https://github.com/pendulum-project/ntpd-rs/blob/v${version}/CHANGELOG.md";
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
}
