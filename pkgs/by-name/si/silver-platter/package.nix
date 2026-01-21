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
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    tag = "v${version}";
    hash = "sha256-/GFTM/VF+b0I8cDY4vkHzSxCBbvpMiLBVVEPFHcn1/Q=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Y16OnSBC4v21NcCeWAwwGoFYJMQq/se25QqvpMyblmk=";
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

  meta = {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "svp";
  };
}
