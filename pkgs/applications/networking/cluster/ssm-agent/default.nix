{ lib
, writeShellScriptBin
, buildGoPackage
, makeWrapper
, fetchFromGitHub
, coreutils
, nettools
, dmidecode
, util-linux
, bashInteractive
}:

let
  # The SSM agent doesn't pay attention to our /etc/os-release yet, and the lsb-release tool
  # in nixpkgs doesn't seem to work properly on NixOS, so let's just fake the two fields SSM
  # looks for. See https://github.com/aws/amazon-ssm-agent/issues/38 for upstream fix.
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
  ];

  configurePhase = ''
    export HOME=$(mktemp -d)

    printf "#!/bin/sh\ntrue" > ./Tools/src/checkstyle.sh

    substituteInPlace agent/platform/platform_unix.go \
        --replace "/usr/bin/uname" "${coreutils}/bin/uname" \
        --replace '"/bin", "hostname"' '"${nettools}/bin/hostname"' \
        --replace '"lsb_release"' '"${fake-lsb-release}/bin/lsb_release"'

    substituteInPlace agent/managedInstances/fingerprint/hardwareInfo_unix.go \
        --replace /usr/sbin/dmidecode ${dmidecode}/bin/dmidecode

    substituteInPlace agent/session/shell/shell_unix.go \
        --replace '"script"' '"${util-linux}/bin/script"'

    # Note: if this step fails, please patch the code to fix it! Please only skip
    # tests if it is not feasible for the test to pass in a sandbox.
    make quick-integtest

    echo "${version}" > VERSION

    make pre-release
    make pre-build
  '';

  buildPhase = ''
    make build-linux
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bin/linux_*/* $out/bin/
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
