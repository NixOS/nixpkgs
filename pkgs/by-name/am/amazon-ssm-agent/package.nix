{ lib
, writeShellScriptBin
, buildGoModule
, makeWrapper
, darwin
, fetchFromGitHub
, coreutils
, nettools
, util-linux
, stdenv
, dmidecode
, bashInteractive
, nix-update-script
, nixosTests
, testers
, amazon-ssm-agent
, overrideEtc ? true
}:

let
  # Tests use lsb_release, so we mock it (the SSM agent used to not
  # read from our /etc/os-release file, but now it does) because in
  # reality, it won't (shouldn't) be used when active on a system with
  # /etc/os-release. If it is, we fake the only two fields it cares about.
  fake-lsb-release = writeShellScriptBin "lsb_release" ''
    . /etc/os-release || true

    case "$1" in
      -i) echo "''${NAME:-unknown}";;
      -r) echo "''${VERSION:-unknown}";;
    esac
  '';

  binaries = {
    "core" = "amazon-ssm-agent";
    "agent" = "ssm-agent-worker";
    "cli-main" = "ssm-cli";
    "worker" = "ssm-document-worker";
    "logging" = "ssm-session-logger";
    "sessionworker" = "ssm-session-worker";
  };
in
buildGoModule rec {
  pname = "amazon-ssm-agent";
  version = "3.3.484.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ssm-agent";
    rev = "refs/tags/${version}";
    hash = "sha256-zWjV56xw4eVHKx3J2DDq6b+RYjU0EL9ShQmb72SVBVk=";
  };

  vendorHash = null;

  patches = [
    # Some tests use networking, so we skip them.
    ./0001-Disable-NIC-tests-that-fail-in-the-Nix-sandbox.patch

    # They used constants from another package that I couldn't figure
    # out how to resolve, so hardcoded the constants.
    ./0002-version-gen-don-t-use-unnecessary-constants.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.DarwinTools
  ];

  # See the list https://github.com/aws/amazon-ssm-agent/blob/3.2.2143.0/makefile#L121-L147
  # The updater is not built because it cannot work on NixOS
  subPackages = [
    "core"
    "agent"
    "agent/cli-main"
    "agent/framework/processor/executer/outofproc/sessionworker"
    "agent/framework/processor/executer/outofproc/worker"
    "agent/session/logging"
  ];

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    printf "#!/bin/sh\ntrue" > ./Tools/src/checkstyle.sh

    substituteInPlace agent/platform/platform_unix.go \
      --replace "/usr/bin/uname" "${coreutils}/bin/uname" \
      --replace '"/bin", "hostname"' '"${nettools}/bin/hostname"' \
      --replace '"lsb_release"' '"${fake-lsb-release}/bin/lsb_release"'

    substituteInPlace agent/session/shell/shell_unix.go \
      --replace '"script"' '"${util-linux}/bin/script"'

    substituteInPlace agent/rebooter/rebooter_unix.go \
      --replace "/sbin/shutdown" "shutdown"

    echo "${version}" > VERSION
  '' + lib.optionalString overrideEtc ''
    substituteInPlace agent/appconfig/constants_unix.go \
      --replace '"/etc/amazon/ssm/"' '"${placeholder "out"}/etc/amazon/ssm/"'
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace agent/managedInstances/fingerprint/hardwareInfo_unix.go \
      --replace /usr/sbin/dmidecode ${dmidecode}/bin/dmidecode
  '';

  preBuild = ''
    # Note: if this step fails, please patch the code to fix it! Please only skip
    # tests if it is not feasible for the test to pass in a sandbox.
    make quick-integtest

    make pre-release
    make pre-build
  '';

  installPhase = ''
    runHook preInstall

    declare -A map=(${builtins.concatStringsSep " " (lib.mapAttrsToList (name: value: "[\"${name}\"]=\"${value}\"") binaries)})

    for key in ''${!map[@]}; do
      install -D -m 0555 -T "$GOPATH/bin/''${key}" "$out/bin/''${map[''${key}]}"
    done

    # These templates retain their `.template` extensions on installation. The
    # amazon-ssm-agent.json.template is required as default configuration when an
    # amazon-ssm-agent.json isn't present. Here, we retain the template to show
    # we're using the default configuration.

    # seelog.xml isn't actually required to run, but it does ship as a template
    # with debian packages, so it's here for reference. Future work in the nixos
    # module could use this template and substitute a different log level.

    install -D -m 0444 -t $out/etc/amazon/ssm amazon-ssm-agent.json.template
    install -D -m 0444 -T seelog_unix.xml $out/etc/amazon/ssm/seelog.xml.template

    runHook postInstall
  '';

  checkFlags = [
    # Skip time dependent/flaky test
    "-skip=TestSendStreamDataMessageWithStreamDataSequenceNumberMutexLocked"
  ];

  postFixup = ''
    wrapProgram $out/bin/amazon-ssm-agent \
      --prefix PATH : "${lib.makeBinPath [ bashInteractive ]}"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) amazon-ssm-agent;
      version = testers.testVersion {
        package = amazon-ssm-agent;
        command = "amazon-ssm-agent --version";
      };
    };
    updateScript = nix-update-script { };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Agent to enable remote management of your Amazon EC2 instance configuration";
    changelog = "https://github.com/aws/amazon-ssm-agent/releases/tag/${version}";
    homepage = "https://github.com/aws/amazon-ssm-agent";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ copumpkin manveru anthonyroussel arianvp ];
  };
}
