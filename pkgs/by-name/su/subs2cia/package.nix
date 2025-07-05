{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "subs2cia ";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dxing97";
    repo = "subs2cia";
    tag = "v${version}";
    hash = "sha256-ZlWoxmrz7WDn46c7KXEqcfqS47z+LhVSNKZbwb5iMOg=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ffmpeg-python
    pycountry
    pysubs2
    tqdm
    pandas
    gevent
    colorlog
  ];

  meta = {
    description = "Extract subtitled dialogue from audiovisual media for use in language acquisition";
    homepage = "https://github.com/dxing97/subs2cia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakuzure ];
  };
}
