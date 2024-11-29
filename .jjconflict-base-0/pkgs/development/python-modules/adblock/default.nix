{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  rustPlatform,
  pkg-config,
  openssl,
  publicsuffix-list,
  pythonOlder,
  libiconv,
  CoreFoundation,
  Security,
  pytestCheckHook,
  toml,
}:

buildPythonPackage rec {
  pname = "adblock";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  # Pypi only has binary releases
  src = fetchFromGitHub {
    owner = "ArniDagur";
    repo = "python-adblock";
    rev = "refs/tags/${version}";
    hash = "sha256-5g5xdUzH/RTVwu4Vfb5Cb1t0ruG0EXgiXjrogD/+JCU=";
  };

  patches = [
    # https://github.com/ArniDagur/python-adblock/pull/91
    (fetchpatch {
      name = "pep-621-compat.patch";
      url = "https://github.com/ArniDagur/python-adblock/commit/2a8716e0723b60390f0aefd0e05f40ba598ac73f.patch";
      hash = "sha256-n9+LDs0no66OdNZxw3aU57ngWrAbmm6hx4qIuxXoatM=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}"
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-1xmYmF5P7a5O9MilxDy+CVhmWMGRetdM2fGvTPy7JmM=";
  };

  nativeBuildInputs =
    [ pkg-config ]
    ++ (with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
    ]);

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      CoreFoundation
      Security
    ];

  PSL_PATH = "${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat";

  nativeCheckInputs = [
    pytestCheckHook
    toml
  ];

  preCheck = ''
    # import from $out instead
    rm -r adblock
  '';

  disabledTestPaths = [
    # relies on directory removed above
    "tests/test_typestubs.py"
  ];

  pythonImportsCheck = [
    "adblock"
    "adblock.adblock"
  ];

  meta = with lib; {
    description = "Python wrapper for Brave's adblocking library";
    homepage = "https://github.com/ArniDagur/python-adblock/";
    changelog = "https://github.com/ArniDagur/python-adblock/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ dotlambda ];
    license = with licenses; [
      asl20 # or
      mit
    ];
  };
}
