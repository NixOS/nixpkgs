{
  lib,
  fetchFromGitHub,
  python3,
  cacert,
  addBinToPathHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gallia";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fraunhofer-AISEC";
    repo = "gallia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2jiD2ZZGinfTT+35TYl3+okWkkTrY1IdfSYbjC+/cvs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.11,<0.10.0" "uv_build"
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = with python3.pkgs; [ uv-build ];

  dependencies = with python3.pkgs; [
    aiosqlite
    argcomplete
    boltons
    construct
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
    changelog = "https://github.com/Fraunhofer-AISEC/gallia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      rumpelsepp
    ];
    platforms = lib.platforms.linux;
  };
})
