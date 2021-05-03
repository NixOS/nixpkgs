{ buildPythonPackage
, sage-src
, sphinx
}:

buildPythonPackage rec {
  version = src.version;
  pname = "sage_docbuild";
  src = sage-src;

  propagatedBuildInputs = [
    sphinx
  ];

  preBuild = ''
    cd build/pkgs/sage_docbuild/src
  '';

  doCheck = false; # we will run tests in sagedoc.nix
}
