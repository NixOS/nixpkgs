{ lib, buildPythonPackage, fetchFromGitLab, fetchurl, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "3.6.21";
  format = "other";

  src = fetchFromGitLab {
    group = "lulzbot3d";
    owner = "cura-le";
    repo = "libarcus";
    rev = "v${version}";
    sha256 = "1ak0d4k745sx7paic27was3s4987z9h3czscjs21hxbi6qy83g99";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://gitlab.com/lulzbot3d/cura-le/libarcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}

