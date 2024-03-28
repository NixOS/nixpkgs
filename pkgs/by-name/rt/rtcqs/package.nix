{ pkgs
, lib
, fetchPypi
, python3
}:

let
  pname = "rtcqs";
  version = "0.5.2";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gxtomDuk+TVcjv3men5eJ9Rwma4R49Bc9qFpcYsrBcg=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools ];
  propagatedBuildInputs = with pkgs; [ tk ] ++ (with python3.pkgs; [ pysimplegui ]);

  meta = with lib; {
    description = "rtcqs is a Python utility to analyze your system and detect possible bottlenecks that could have a negative impact on the performance of your system when working with Linux audio.";
    homepage = "https://codeberg.org/rtcqs/rtcqs";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "rtcqs";
  };
}
