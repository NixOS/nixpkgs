{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "subs2cia ";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "dxing97";
    repo = "subs2cia";
    rev = "subs2cia-${version}";
    hash = "sha256-GSp1aNZ9rz5f18HnnM0Q5reg2ZMEPrZ8Z3qyUQlYQs0=";
  };

  propagatedBuildInputs = with python3Packages; [
    ffmpeg-python
    pycountry
    pysubs2
    setuptools
    tqdm
    pandas
    gevent
    colorlog
  ];

  meta = with lib; {
    description =
      "Extract subtitled dialogue from audiovisual media for use in language acquisition";
    homepage = "https://github.com/dxing97/subs2cia";
    license = licenses.mit;
    maintainers = with maintainers; [ jakuzure ];
  };
}
