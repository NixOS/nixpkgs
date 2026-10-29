{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
  resvg,
}:

let
  version = "3.2.0";
  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "gerbolyze";
    tag = "v${version}";
    hash = "sha256-T3e0qoVD98u2lgCmQvof2SOqV8WkBkZrhnccURlJqsA=";
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

    meta = {
      description = "SVG-flatten SVG downconverter";
      homepage = "https://github.com/jaseg/gerbolyze";
      license = with lib.licenses; [ agpl3Plus ];
      maintainers = with lib.maintainers; [ wulfsta ];
      mainProgram = "svg-flatten";
      platforms = lib.platforms.linux;
    };
  };
in
python3Packages.buildPythonApplication {
  inherit version src;
  pname = "gerbolyze";
  pyproject = true;

  build-system = with python3Packages; [ uv-build ];

  pythonRemoveDeps = [
    # we already provide svg-flatten through a binary on the PATH
    "resvg-wasi"
    "svg-flatten-wasi"
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    click
    numpy
    python-slugify
    lxml
    gerbonara
    resvg
  ];

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

  preCheck = ''
    substituteInPlace tests/test_integration.py \
      --replace-fail "'gerbolyze'" "'${placeholder "out"}/bin/gerbolyze'"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Directly render SVG overlays into Gerber and Excellon files";
    homepage = "https://github.com/jaseg/gerbolyze";
    license = with lib.licenses; [ agpl3Plus ];
    maintainers = with lib.maintainers; [ wulfsta ];
    mainProgram = "gerbolyze";
    platforms = lib.platforms.linux;
  };
}
