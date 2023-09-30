{ lib
, writeShellScriptBin
, buildGoPackage
, makeWrapper
, fetchFromGitHub
, coreutils
, nettools
, busybox
, util-linux
, stdenv
, dmidecode
, bashInteractive
, nix-update-script
, testers
, ssm-agent
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
in
buildGoPackage rec {
  pname = "amazon-ssm-agent";
  version = "3.2.1630.0";

  goPackagePath = "github.com/aws/${pname}";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    rev = "refs/tags/${version}";
    owner = "aws";
    repo = "amazon-ssm-agent";
    hash = "sha256-0tN0rBfz2VZ4UkYLFDGg9218O9vyyRT2Lrppu9TETao=";
  };

  patches = [
    # Some tests use networking, so we skip them.
    ./0001-Disable-NIC-tests-that-fail-in-the-Nix-sandbox.patch

    # They used constants from another package that I couldn't figure
    # out how to resolve, so hardcoded the constants.
    ./0002-version-gen-don-t-use-unnecessary-constants.patch
  ];

  # See the list https://github.com/aws/amazon-ssm-agent/blob/3.2.1630.0/makefile#L120-L138
  # The updater is not built because it cannot work on NixOS
  subPackages = [
    "core"
    "agent"
    "agent/cli-main"
    "agent/framework/processor/executer/outofproc/worker"
    "agent/session/logging"
    "agent/framework/processor/executer/outofproc/sessionworker"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

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
    pushd go/src/${goPackagePath}

    # Note: if this step fails, please patch the code to fix it! Please only skip
    # tests if it is not feasible for the test to pass in a sandbox.
    make quick-integtest

    make pre-release
    make pre-build

    popd
  '';

  postBuild = ''
    pushd go/bin

    mv core amazon-ssm-agent
    mv agent ssm-agent-worker
    mv cli-main ssm-cli
    mv worker ssm-document-worker
    mv logging ssm-session-logger
    mv sessionworker ssm-session-worker

    popd
  '';

  # These templates retain their `.template` extensions on installation. The
  # amazon-ssm-agent.json.template is required as default configuration when an
  # amazon-ssm-agent.json isn't present. Here, we retain the template to show
  # we're using the default configuration.

  # seelog.xml isn't actually required to run, but it does ship as a template
  # with debian packages, so it's here for reference. Future work in the nixos
  # module could use this template and substitute a different log level.
  postInstall = ''
    mkdir -p $out/etc/amazon/ssm
    cp go/src/${goPackagePath}/amazon-ssm-agent.json.template $out/etc/amazon/ssm/amazon-ssm-agent.json.template
    cp go/src/${goPackagePath}/seelog_unix.xml $out/etc/amazon/ssm/seelog.xml.template
  '';

  postFixup = ''
    wrapProgram $out/bin/amazon-ssm-agent --prefix PATH : ${bashInteractive}/bin
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = ssm-agent;
      command = "amazon-ssm-agent --version";
    };
  };

  meta = with lib; {
    description = "Agent to enable remote management of your Amazon EC2 instance configuration";
    changelog = "https://github.com/aws/amazon-ssm-agent/releases/tag/${version}";
    homepage = "https://github.com/aws/amazon-ssm-agent";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ copumpkin manveru anthonyroussel ];

    # Darwin support is broken
    broken = stdenv.isDarwin;
  };
}
