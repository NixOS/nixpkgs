{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urh-${version}";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "v${version}";
    sha256 = "137dsxs4i0lmxwp31g8fzwpwv1i8rsiir9gxvs5cmnwsrbcrdvxh";
  };

  propagatedBuildInputs = with python3Packages; [ pyqt5 numpy psutil cython ];

  doCheck = false;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.asl20;
    platform = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
