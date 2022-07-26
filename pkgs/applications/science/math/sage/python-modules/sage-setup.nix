{ lib
, buildPythonPackage
, sage-src
, pkgconfig # the python module, not the pkg-config alias
}:

buildPythonPackage rec {
  version = src.version;
  pname = "sage-setup";
  src = sage-src;

  buildInputs = [
    pkgconfig
  ];

  preBuild = ''
    cd pkgs/sage-setup
  '';

  doCheck = false; # sagelib depends on sage-setup, but sage-setup's tests depend on sagelib

  meta = with lib; {
    description = "Build system of the Sage library";
    homepage = "https://www.sagemath.org";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
  };
}
