{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "visdom";
  version = "0.1.8.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "09kiczx2i5asqsv214fz7sx8wlyldgbqvxwrd0alhjn24cvx4fn7";
  };

  propagatedBuildInputs = with python3Packages; [
    jsonpatch
    pillow
    pyzmq
    requests
    scipy
    torchfile
    tornado
    websocket_client
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/facebookresearch/visdom";
    description = "A tool for visualizing live, rich data for Torch and Numpy";
    license = licenses.cc-by-nc-40;
  };
}
