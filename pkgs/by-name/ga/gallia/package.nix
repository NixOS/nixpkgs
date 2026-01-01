{
  lib,
  fetchFromGitHub,
  python3,
  cacert,
  addBinToPathHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gallia";
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0.0b2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fraunhofer-AISEC";
    repo = "gallia";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2jiD2ZZGinfTT+35TYl3+okWkkTrY1IdfSYbjC+/cvs=";
=======
    hash = "sha256-CZsVd9ob4FHC9KeepK7OHWatVTJUiJEjqtaylhD+yS0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "uv_build>=0.9.11,<0.10.0" "uv_build"
=======
      --replace-fail "uv_build>=0.8.11,<0.9.0" "uv_build"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = with python3.pkgs; [ uv-build ];

  dependencies = with python3.pkgs; [
    aiosqlite
    argcomplete
    boltons
    construct
<<<<<<< HEAD
=======
    more-itertools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
