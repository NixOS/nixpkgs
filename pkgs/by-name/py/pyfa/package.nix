{
  lib,
  python3Packages,
  fetchFromGitHub,

  # dependecies
  webkitgtk_4_1,
  python312,
}:
let
  version = "2.61.0";
in
python3Packages.buildPythonApplication rec {
  inherit version;
  pname = "pyfa";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "pyfa-org";
    repo = "Pyfa";
    rev = "v${version}";
    hash = "sha256-VSuRQugUODc+LbhKbzsA09pnqPEIAt0pQS2An/p7r9A=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    wxpython
    logbook
    matplotlib
    dateutil
    requests
    sqlalchemy_1_4
    cryptography
    markdown2
    beautifulsoup4
    pyaml
    roman
    numpy
    python-jose
    requests-cache

    # non python dependency
    webkitgtk_4_1
  ];

  preBuild = ''
    cat > setup.py << EOF
    from setuptools import setup

    setup(
      name='${pname}',
      version='${version}',
      scripts=[
        '${pname}.py',
      ],
      package_dir=' ',
      packages=setuptools.find_packages(),
    )
    EOF

    touch __init__.py
  '';

  installPhase = ''
    PYTHONDONTWRITEBYTECODE=1 ${python312}/bin/python3 db_update.py

    install -dm755 $out/bin/pyfa
    install -Dm755 pyfa.py $out/bin/pyfa

    install -Dm644 config.py $out/bin/pyfa
    install -Dm644 db_update.py $out/bin/pyfa
    install -Dm644 eve.db $out/bin/pyfa
    install -Dm644 README.md $out/bin/pyfa
    install -Dm644 version.yml $out/bin/pyfa

    cp -a eos $out/bin/pyfa
    cp -a graphs $out/bin/pyfa
    cp -a gui $out/bin/pyfa
    cp -a imgs $out/bin/pyfa
    cp -a service $out/bin/pyfa
    cp -a utils $out/bin/pyfa
  '';

  doCheck = false;

  meta = {
    description = "Python fitting assistant, cross-platform fitting tool for EVE Online";
    homepage = "https://github.com/pyfa-org/Pyfa";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      toasteruwu
      cholli
    ];
    mainProgram = "pyfa";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.linux;
  };
}
