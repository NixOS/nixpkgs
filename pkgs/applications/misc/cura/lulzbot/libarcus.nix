{ stdenv, buildPythonPackage, fetchgit, fetchurl, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage {
  pname = "libarcus";
  version = "3.6.18";
  format = "other";

  src = fetchgit {
    url = https://code.alephobjects.com/source/arcus.git;
    rev = "c795c0644591703ce04e1fd799fc97b1539031aa";
    sha256 = "1yap9wbqxbjx3kqyqcsldny4mlcm33ywiwpdjlfgs0wjahfg4ip0";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  meta = with stdenv.lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = https://code.alephobjects.com/source/arcus/;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}

