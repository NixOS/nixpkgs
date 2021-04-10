{ lib, buildPythonPackage, pythonOlder, fetchFromGitLab, cmake, sip }:

buildPythonPackage rec {
  pname = "libsavitar-lulzbot";
  name = "libsavitar-lulzbot";
  version = "3.6.21";
  format = "other";

  src = fetchFromGitLab {
    group = "lulzbot3d";
    owner = "cura-le";
    repo = "libsavitar";
    rev = "v${version}";
    sha256 = "1wm5ii3cmni8dk3c65kw4wglpypkdsfpgd480d3hc1r5bqpq0d6j";
  };

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ sip ];

  disabled = pythonOlder "3.4.0";

  meta = with lib; {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = "https://gitlab.com/lulzbot3d/cura-le/libsavitar";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ chaduffy ];
  };
}
