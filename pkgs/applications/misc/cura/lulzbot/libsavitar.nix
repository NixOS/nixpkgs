{ stdenv, buildPythonPackage, pythonOlder, fetchgit, cmake, sip }:

buildPythonPackage {
  pname = "libsavitar-lulzbot";
  name = "libsavitar-lulzbot";
  version = "3.6.21";
  format = "other";

  src = fetchgit {
    url = https://code.alephobjects.com/source/savitar.git;
    rev = "ee8ada42c55f54727ce4d275c294ba426d3d8234";
    sha256 = "1wm5ii3cmni8dk3c65kw4wglpypkdsfpgd480d3hc1r5bqpq0d6j";
  };

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ sip ];

  disabled = pythonOlder "3.4.0";

  meta = with stdenv.lib; {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = https://github.com/Ultimaker/libSavitar;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ chaduffy ];
  };
}
