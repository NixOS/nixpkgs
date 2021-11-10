{ lib
, cacert
, fetchFromGitHub
, python3Packages
}:

let chia = python3Packages.buildPythonApplication rec {
  pname = "chia";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "chia-blockchain";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-TzSBGjgaE0IWaqJcCIoO/u+gDh17NtAqhE8ldbbjNIE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="

    cp ${cacert}/etc/ssl/certs/ca-bundle.crt mozilla-ca/cacert.pem
  '';

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
    colorama
    colorlog
    concurrent-log-handler
    cryptography
    dnspython
    fasteners
    keyrings-cryptfile
    pyyaml
    setproctitle
    setuptools # needs pkg_resources at runtime
    sortedcontainers
    watchdog
    websockets
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  # Testsuite is expensive and non-deterministic, so it is available in
  # passthru.tests instead.
  doCheck = false;

  disabledTests = [
    "test_spend_through_n"
    "test_spend_zero_coin"
    "test_default_cached_master_passphrase"
    "test_using_legacy_keyring"
  ];

  preCheck = ''
    export HOME=`mktemp -d`
  '';

  passthru.tests = {
    chiaWithTests = chia.overrideAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Chia is a modern cryptocurrency built from scratch, designed to be efficient, decentralized, and secure.";
    license = with licenses; [ asl20 ];
    maintainers = teams.chia.members;
    platforms = platforms.all;
  };
};
in chia
