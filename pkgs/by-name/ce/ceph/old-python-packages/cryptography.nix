# This older version only exists because `ceph` needs it, see its package.
{
  lib,
  stdenv,
  callPackage,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  rustPlatform,
  cargo,
  rustc,
  setuptoolsRustBuildHook,
  openssl,
  Security ? null,
  isPyPy,
  cffi,
  pkg-config,
  pytestCheckHook,
  pytest-subtests,
  pythonOlder,
  pretend,
  libiconv,
  libxcrypt,
  iso8601,
  py,
  pytz,
  hypothesis,
}:

let
  cryptography-vectors = callPackage ./cryptography-vectors.nix { };
in
buildPythonPackage rec {
  pname = "cryptography";
  version = "40.0.1"; # Also update the hash in vectors.nix
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KAPy+LHpX2FEGZJsfm9V2CivxhTKXtYVQ4d65mjMNHI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-pZHu3Oo9DWRAtldU0UvrH1FIg0bEvyfizPUhj9IBL58=";
  };

  # Since Cryptography v40 is quite outdated, we need to backport
  # security fixes that are only available in newer versions.
  patches = [
    # Fix https://nvd.nist.gov/vuln/detail/CVE-2023-49083 which has no upstream backport.
    # See https://github.com/pyca/cryptography/commit/f09c261ca10a31fe41b1262306db7f8f1da0e48a#diff-f5134bf8f3cf0a5cc8601df55e50697acc866c603a38caff98802bd8e17976c5R1893
    ./python-cryptography-Cherry-pick-fix-for-CVE-2023-49083-on-cryptography-40.patch

    # Fix https://nvd.nist.gov/vuln/detail/CVE-2024-26130
    # See https://github.com/pyca/cryptography/commit/97d231672763cdb5959a3b191e692a362f1b9e55
    (fetchpatch {
      name = "python-cryptography-CVE-2024-26130-dont-crash-when-a-PKCS-12-key-and-cert-dont-match-mmap-mode.patch";
      url = "https://github.com/pyca/cryptography/commit/97d231672763cdb5959a3b191e692a362f1b9e55.patch";
      hash = "sha256-l45NOzOWhHW4nY4OIRpdjYQRvUW8BROGWdpkAtvVn0Y=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-disable" ""
  '';

  cargoRoot = "src/rust";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptoolsRustBuildHook
    cargo
    rustc
    pkg-config
  ]
  ++ lib.optionals (!isPyPy) [ cffi ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optionals (pythonOlder "3.9") [ libxcrypt ];

  propagatedBuildInputs = lib.optionals (!isPyPy) [ cffi ];

  nativeCheckInputs = [
    cryptography-vectors
    hypothesis
    iso8601
    pretend
    py
    pytestCheckHook
    pytest-subtests
    pytz
  ];

  pytestFlags = [ "--disable-pytest-warnings" ];

  disabledTestPaths = [
    # save compute time by not running benchmarks
    "tests/bench"
    # aarch64-darwin forbids W+X memory, but this tests depends on it:
    # * https://cffi.readthedocs.io/en/latest/using.html#callbacks
    # furthermore, this test fails with OpenSSL 3.6.0, probably due to:
    # * https://github.com/openssl/openssl/issues/28757
    # * https://github.com/openssl/openssl/issues/28770
    # * https://github.com/openssl/openssl/issues/28888
    "tests/hazmat/backends/test_openssl_memleak.py"
  ];

  meta = with lib; {
    description = "Package which provides cryptographic recipes and primitives";
    longDescription = ''
      Cryptography includes both high level recipes and low level interfaces to
      common cryptographic algorithms such as symmetric ciphers, message
      digests, and key derivation functions.
      Our goal is for it to be your "cryptographic standard library". It
      supports Python 2.7, Python 3.5+, and PyPy 5.4+.
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog =
      "https://cryptography.io/en/latest/changelog/#v" + replaceStrings [ "." ] [ "-" ] version;
    license = with licenses; [
      asl20
      bsd3
      psfl
    ];
    maintainers = with maintainers; [ nh2 ];
  };
}
