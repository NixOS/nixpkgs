{
  lib,
  python3Packages,
  fetchFromGitHub,

  # nativeBuildInputs
  makeWrapper,

  # dependencies
  pdk-ciel,

  # wrapper runtime dependencies
  abc-verifier,
  klayout,
  magic-vlsi,
  netgen-vlsi,
  openroad,
  ruby,
  verilator,
  yosys,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "librelane";
  version = "3.0.0.dev47-unstable-2026-01-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "librelane";
    repo = "librelane";
    rev = "f1efecac3151f3275fa2ea7d656f8ea7e3225a9d";
    hash = "sha256-XZHypZ+Ht1Zbb0N9VBUmrZKwWuqYA0/w7DpZBOO9KU8=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  pythonRelaxDeps = [
    "click"
  ];

  dependencies = with python3Packages; [
    click
    cloup
    deprecated
    httpx
    libparse-python
    lxml
    numpy
    pandas
    pdk-ciel
    psutil
    python3Packages.klayout
    pyyaml
    rapidfuzz
    rich
    semver
    tkinter
    yamlcore
  ];

  postInstall = ''
    cp -r librelane/scripts $out/${python3Packages.python.sitePackages}/librelane/
    cp -r librelane/examples $out/${python3Packages.python.sitePackages}/librelane/
  '';

  postFixup = ''
    wrapProgram $out/bin/librelane \
      --suffix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : ${
        lib.makeBinPath [
          abc-verifier
          klayout
          magic-vlsi
          netgen-vlsi
          openroad
          ruby
          verilator
          yosys
        ]
      }
  '';

  meta = {
    description = "ASIC implementation flow infrastructure";
    homepage = "https://github.com/librelane/librelane";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.gonsolo ];
    mainProgram = "librelane";
  };
})
