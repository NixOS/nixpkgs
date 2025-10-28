{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
  resvg,
}:

let
  version = "3.1.9";
  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "gerbolyze";
    tag = "v${version}";
    hash = "sha256-bisLln3Y239HuJt0MkrCU+6vLLbEDxfTjEJMkcbE/wE=";
    fetchSubmodules = true;
  };

  svg-flatten = stdenv.mkDerivation rec {
    inherit version src;
    pname = "svg-flatten";

    sourceRoot = "${src.name}/svg-flatten";

    preInstall = ''
      mkdir -p $out/bin
    '';

    installFlags = [ "PREFIX=$(out)" ];

    meta = with lib; {
      description = "SVG-flatten SVG downconverter";
      homepage = "https://github.com/jaseg/gerbolyze";
      license = with licenses; [ agpl3Plus ];
      maintainers = with maintainers; [ wulfsta ];
      mainProgram = "svg-flatten";
      platforms = platforms.linux;
    };
  };
in
python3Packages.buildPythonApplication rec {
  inherit version src;
  pname = "gerbolyze";
  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  pythonRemoveDeps = [
    # we already provide svg-flatten through a binary on the PATH
    "svg-flatten-wasi"
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    click
    numpy
    python-slugify
    lxml
    gerbonara
  ];

  preConfigure = ''
    # setup.py tries to execute a call to git in a subprocess, this avoids it.
    substituteInPlace setup.py \
      --replace-fail "version = get_version()," \
                     "version = '${version}'," \

    # setup.py tries to execute a call to git in a subprocess, this avoids it.
    substituteInPlace setup.py \
      --replace-fail "long_description=format_readme_for_pypi()," \
                     "long_description='\n'.join(Path('README.rst').read_text().splitlines()),"
  '';

  pythonImportsCheck = [ "gerbolyze" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    resvg
    svg-flatten
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        resvg
        svg-flatten
      ]
    }"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Directly render SVG overlays into Gerber and Excellon files";
    homepage = "https://github.com/jaseg/gerbolyze";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ wulfsta ];
    mainProgram = "gerbolyze";
    platforms = platforms.linux;
  };
}
