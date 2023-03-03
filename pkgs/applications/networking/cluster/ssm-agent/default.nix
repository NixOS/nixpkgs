{ lib
, writeShellScriptBin
, buildGoPackage
, makeWrapper
, fetchFromGitHub
, fetchpatch
, coreutils
, nettools
, dmidecode
, util-linux
, bashInteractive
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
  version = "3.0.755.0";

  goPackagePath = "github.com/aws/${pname}";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    rev = version;
    owner = "aws";
    repo = "amazon-ssm-agent";
    hash = "sha256-yVQJL1MJ1JlAndlrXfEbNLQihlbLhSoQXTKzJMRzhao=";
  };

  patches = [
    # Some tests use networking, so we skip them.
    ./0001-Disable-NIC-tests-that-fail-in-the-Nix-sandbox.patch

    # They used constants from another package that I couldn't figure
    # out how to resolve, so hardcoded the constants.
    ./0002-version-gen-don-t-use-unnecessary-constants.patch

    (fetchpatch {
      name = "CVE-2022-29527.patch";
      url = "https://github.com/aws/amazon-ssm-agent/commit/0fe8ae99b2ff25649c7b86d3bc05fc037400aca7.patch";
      sha256 = "sha256-5g14CxhsHLIgs1Vkfw8FCKEJ4AebNqZKf3ZzoAN/T9U=";
    })
  ];

  preConfigure = ''
    rm -r ./Tools/src/goreportcard
    printf "#!/bin/sh\ntrue" > ./Tools/src/checkstyle.sh

    substituteInPlace agent/platform/platform_unix.go \
        --replace "/usr/bin/uname" "${coreutils}/bin/uname" \
        --replace '"/bin", "hostname"' '"${nettools}/bin/hostname"' \
        --replace '"lsb_release"' '"${fake-lsb-release}/bin/lsb_release"'

    substituteInPlace agent/managedInstances/fingerprint/hardwareInfo_unix.go \
        --replace /usr/sbin/dmidecode ${dmidecode}/bin/dmidecode

    substituteInPlace agent/session/shell/shell_unix.go \
        --replace '"script"' '"${util-linux}/bin/script"'

    echo "${version}" > VERSION
  '' + lib.optionalString overrideEtc ''
    substituteInPlace agent/appconfig/constants_unix.go \
      --replace '"/etc/amazon/ssm/"' '"${placeholder "out"}/etc/amazon/ssm/"'
  '';

  preBuild = ''
    cp -r go/src/${goPackagePath}/vendor/src go

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

    rm integration-cli versiongenerator generator

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

  meta = with lib; {
    description = "Agent to enable remote management of your Amazon EC2 instance configuration";
    homepage = "https://github.com/aws/amazon-ssm-agent";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ copumpkin manveru ];
  };
}
