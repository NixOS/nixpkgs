{ lib

, buildPythonPackage
, notmuch
, python
, cffi
}:

buildPythonPackage {
  pname = "notmuch2";
  inherit (notmuch) version src;

  sourceRoot = "notmuch-${notmuch.version}/bindings/python-cffi";

  buildInputs = [ python notmuch cffi ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "notmuch2" ];

  meta = with lib; {
    description = "Pythonic bindings for the notmuch mail database using CFFI";
    homepage = "https://notmuchmail.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ teto ];
  };
}
