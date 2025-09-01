{
  lib,
  fetchFromGitHub,
  python3,
  cacert,
  addBinToPathHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gallia";
  version = "2.0.0a4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fraunhofer-AISEC";
    repo = "gallia";
    tag = "v${version}";
    hash = "sha256-by2zlfVN/FUNU9d5nn4JZ8xzto3k60DITPYhYqwm3Ms=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    aiosqlite
    argcomplete
    boltons
    construct
    more-itertools
    platformdirs
    pydantic
    tabulate
    zstandard
  ];

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeCheckInputs =
    with python3.pkgs;
    [
      pytestCheckHook
      pytest-asyncio
    ]
    ++ [
      addBinToPathHook
    ];

  pythonImportsCheck = [ "gallia" ];

  meta = {
    description = "Extendable Pentesting Framework for the Automotive Domain";
    homepage = "https://github.com/Fraunhofer-AISEC/gallia";
    changelog = "https://github.com/Fraunhofer-AISEC/gallia/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      fab
      rumpelsepp
    ];
    platforms = lib.platforms.linux;
  };
}
