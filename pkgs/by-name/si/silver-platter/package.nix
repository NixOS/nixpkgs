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
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    tag = "v${version}";
    hash = "sha256-CvFnmGMV46nX6d568pZPqmDEyLZkDnDPpTtf0dMJd4U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-nMCOEb1WTG320ozno0H/5JeZql5TqFakO8TghjbKbiQ=";
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
