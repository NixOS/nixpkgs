{
  lib,
  python3,
  fetchFromGitHub,
  imagemagick,

  makeFontsConf,
  roboto,
  ghostscript,
  librsvg,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "kidiff";
  version = "2.5.9";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "KiDiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tIK8VwTk07NpIsEAC/XdKq2jSto7lacbNZUuqw9lkaM=";
  };

  postPatch = ''
    substituteInPlace tests/utils/context.py \
      --replace-fail "COVERAGE_SCRIPT = 'python3-coverage'" "COVERAGE_SCRIPT = 'coverage3'" \
      --replace-fail "ae = int(res.stderr.decode())" "ae = int(res.stderr.decode().strip().split(' ')[0])"
  '';

  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    kiauto
    kicad
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    coverage
    imagemagick
    ghostscript
    kiauto
    kicad
    librsvg
  ];
  pytestFlags = [ "--test_dir=kidiff_tests" ];

  preCheck = ''
    export HOME=$TMPDIR
    export FONTCONFIG_FILE=${
      makeFontsConf {
        fontDirectories = [ roboto ];
      }
    }
  '';

  meta = {
    description = "PDF file generator showing the diff between two KiCad PCB/SCH files";
    homepage = "https://github.com/INTI-CMNB/KiDiff";
    changelog = "https://github.com/INTI-CMNB/KiDiff/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
