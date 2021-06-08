{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "chia";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "chia-blockchain";
    rev = version;
    sha256 = "05hcckkv3vhz172w9kp5lh4srakizx1l383dijs50vgx2bj30m8v";
  };

  patches = [
    # tweak version requirements to what's available in Nixpkgs
    ./dependencies.patch
  ];

  nativeBuildInputs = [
    python3Packages.setuptools-scm
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    aiosqlite
    bitstring
    blspy
    chiapos
    chiavdf
    chiabip158
    click
    clvm
    clvm-rs
    clvm-tools
    colorlog
    concurrent-log-handler
    cryptography
    dnspython
    keyrings-cryptfile
    pyyaml
    setproctitle
    setuptools # needs pkg_resources at runtime
    sortedcontainers
    websockets
  ];

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  disabledTests = [
    "test_spend_through_n"
    "test_spend_zero_coin"
  ];

  preCheck = ''
    export HOME=`mktemp -d`
  '';

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Chia is a modern cryptocurrency built from scratch, designed to be efficient, decentralized, and secure.";
    license = with licenses; [ asl20 ];
    maintainers = teams.chia.members;
    platforms = platforms.all;
  };
}
