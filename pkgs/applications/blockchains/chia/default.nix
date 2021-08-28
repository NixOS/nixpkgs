{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "chia";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "chia-blockchain";
    rev = version;
    sha256 = "ZUxWOlJGQpeQCtWt0PSdcbMackHdeuNFkxHvYDPcU8Y=";
  };

  patches = [
    # tweak version requirements to what's available in Nixpkgs
    ./dependencies.patch
  ];

  nativeBuildInputs = [
    python3Packages.setuptools-scm
  ];

  # give a hint to setuptools_scm on package version
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
