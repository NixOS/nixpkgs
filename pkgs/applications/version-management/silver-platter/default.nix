{
  lib,
  stdenv,
  buildPythonApplication,
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
  version = "0.5.46";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    tag = "v${version}";
    hash = "sha256-mLph+S86BXjD/Cuu0VR65Hoic8Dr/cIWhy/8MnxB/ik=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-l5IMe+EXoSF4w5ubXJ8kUZvpbX5CX1nkOKIvTL0lMKY=";
  };

  build-system = [
    setuptools-rust
    setuptools
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  dependencies = [
    breezy
    dulwich
    jinja2
    pyyaml
    ruamel-yaml
  ];

  pythonImportsCheck = [ "silver_platter" ];

  meta = {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "debian-svp";
  };
}
