{
  lib,
  fetchFromGitHub,
  python3,
  cacert,
  addBinToPathHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gallia";
  version = "2.0.0b2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fraunhofer-AISEC";
    repo = "gallia";
    tag = "v${version}";
    hash = "sha256-CZsVd9ob4FHC9KeepK7OHWatVTJUiJEjqtaylhD+yS0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.11,<0.9.0" "uv_build"
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = with python3.pkgs; [ uv-build ];

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
    changelog = "https://github.com/Fraunhofer-AISEC/gallia/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      rumpelsepp
    ];
    platforms = lib.platforms.linux;
  };
}
