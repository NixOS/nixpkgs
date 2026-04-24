{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,

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
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "librelane";
    repo = "librelane";
    tag = finalAttrs.version;
    hash = "sha256-JxWuaOBhkjjw4sp7l++QF+0EzGIhPAOaJcKwwmdTg+w=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/librelane/librelane/pull/927.patch";
      hash = "sha256-zGOQHV0caIJh9YTNM3sFWU7HYIwk1td9On82RUoJ3y8=";
    })
  ];

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
    # Create the site-packages subdirectory for librelane
    dest="$out/${python3Packages.python.sitePackages}/librelane"
    mkdir -p "$dest"

    # Copy scripts and examples from the source into the installation
    cp -r librelane/scripts "$dest/"
    cp -r librelane/examples "$dest/"
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ASIC implementation flow infrastructure";
    homepage = "https://github.com/librelane/librelane";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.gonsolo ];
    mainProgram = "librelane";
  };
})
