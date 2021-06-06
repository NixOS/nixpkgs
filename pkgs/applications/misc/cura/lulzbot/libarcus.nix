{ lib, buildPythonPackage, fetchgit, fetchurl, cmake, sip_4, protobuf, pythonOlder }:

buildPythonPackage {
  pname = "libarcus";
  version = "3.6.21";
  format = "other";

  src = fetchgit {
    url = "https://code.alephobjects.com/source/arcus.git";
    rev = "aeda02d7727f45b657afb72cef203283fbf09325";
    sha256 = "1ak0d4k745sx7paic27was3s4987z9h3czscjs21hxbi6qy83g99";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip_4 ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://code.alephobjects.com/source/arcus/";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}

