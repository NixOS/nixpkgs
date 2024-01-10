{ buildPythonApplication
, lib
, fetchFromGitHub
, setuptools
, setuptools-rust
, rustPlatform
, cargo
, rustc
, breezy
, dulwich
, jinja2
, pyyaml
, ruamel-yaml
}:

buildPythonApplication rec {
  pname = "silver-platter";
  version = "0.5.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    rev = version;
    hash = "sha256-QkTT9UcJuGDAwpp/CtXobPvfTYQzFakBR72MhF//Bpo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-QLnKu9D23FVp1jCSuxN3odPZ1ToAZ6i/FNS8BkmNuQw=";
  };

  propagatedBuildInputs = [ setuptools breezy dulwich jinja2 pyyaml ruamel-yaml ];
  nativeBuildInputs = [ setuptools-rust rustPlatform.cargoSetupHook cargo rustc ];

  meta = with lib; {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lukegb ];
    mainProgram = "svp";
  };
}
