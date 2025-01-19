{
  lib,
  buildPythonPackage,
  fetchPypi,
  ifaddr,
  typing,
  pythonOlder,
  netifaces,
  six,
  enum-compat,
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.19.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ykzg730n915qbrq9bn5pn06bv6rb5zawal4sqjyfnjjm66snkj3";
  };

  propagatedBuildInputs = [
    netifaces
    six
    enum-compat
    ifaddr
  ] ++ lib.optionals (pythonOlder "3.5") [ typing ];

  meta = {
    description = "Pure python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
}
