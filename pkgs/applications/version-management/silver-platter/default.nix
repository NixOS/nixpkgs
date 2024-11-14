{ buildPythonApplication
, lib
, stdenv
, fetchFromGitHub
, pkg-config
, setuptools
, setuptools-rust
, rustPlatform
, cargo
, rustc
, breezy
, dulwich
, jinja2
, libiconv
, openssl
, pyyaml
, ruamel-yaml
}:

buildPythonApplication rec {
  pname = "silver-platter";
  version = "0.5.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    rev = version;
    hash = "sha256-k+C4jrC4FO/yy9Eb6x4lv1zyyp/eGkpMcDqZ0KoxfBs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-+EUj6iBnHF4zlOAAfaHy5V/z6CCD/LFksBClE4FaHHc=";
  };

  propagatedBuildInputs = [ setuptools breezy dulwich jinja2 pyyaml ruamel-yaml ];
  nativeBuildInputs = [ setuptools-rust rustPlatform.cargoSetupHook cargo rustc ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
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
