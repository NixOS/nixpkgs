{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "cjkwrap";
  version = "2.2";
  src = fetchPypi {
    pname = "CJKwrap";
    inherit version;
    sha256 = "1b603sg6c2gv9vmlxwr6r1qvhadqk3qp6vifmijris504zjx5ix2";
  };

  pythonImportsCheck = [ "cjkwrap" ];

  meta = with lib; {
    description = "Library for wrapping and filling CJK text";
    homepage = "https://f.gallai.re/cjkwrap";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.kaction ];
  };
}
