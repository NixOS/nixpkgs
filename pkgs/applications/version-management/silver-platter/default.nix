{
  buildPythonApplication,
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  setuptools,
  setuptools-rust,
  rustPlatform,
  cargo,
  rustc,
  breezy,
  dulwich,
  jinja2,
  libiconv,
  openssl,
  pyyaml,
  ruamel-yaml,
}:

buildPythonApplication rec {
  pname = "silver-platter";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    tag = "v${version}";
    hash = "sha256-b7EYDLoFP77bLk6kodRH4beRLZBnarEZDv3uNg8kFW4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-nab0Kkn7JrlnrChnC/WERnhyZEywzZ0LP/bmaAu/G4s=";
  };

  propagatedBuildInputs = [
    setuptools
    breezy
    dulwich
    jinja2
    pyyaml
    ruamel-yaml
  ];
  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  pythonImportsCheck = [ "silver_platter" ];

  meta = {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "svp";
  };
}
