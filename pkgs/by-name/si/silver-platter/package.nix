{
  python3Packages,
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  cargo,
  rustc,
  libiconv,
  openssl,
}:

python3Packages.buildPythonApplication rec {
  pname = "silver-platter";
  version = "0.5.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    rev = version;
    hash = "sha256-k+C4jrC4FO/yy9Eb6x4lv1zyyp/eGkpMcDqZ0KoxfBs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-hZQfzaLvHSN/hGR5vn+/2TRH6GwDTTp+UcnePXY7JlM=";
  };

  dependencies = with python3Packages; [
    setuptools
    breezy
    dulwich
    jinja2
    pyyaml
    ruamel-yaml
  ];
  nativeBuildInputs = [
    python3Packages.setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  pythonImportsCheck = [ "silver_platter" ];

  meta = with lib; {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lukegb ];
    mainProgram = "svp";
  };
}
