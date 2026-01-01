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
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.5.20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-/GFTM/VF+b0I8cDY4vkHzSxCBbvpMiLBVVEPFHcn1/Q=";
=======
    rev = version;
    hash = "sha256-k+C4jrC4FO/yy9Eb6x4lv1zyyp/eGkpMcDqZ0KoxfBs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-Y16OnSBC4v21NcCeWAwwGoFYJMQq/se25QqvpMyblmk=";
=======
    hash = "sha256-hZQfzaLvHSN/hGR5vn+/2TRH6GwDTTp+UcnePXY7JlM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lukegb ];
=======
  meta = with lib; {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lukegb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "svp";
  };
}
