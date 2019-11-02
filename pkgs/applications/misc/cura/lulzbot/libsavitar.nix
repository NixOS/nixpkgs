{ stdenv, buildPythonPackage, pythonOlder, fetchgit, cmake, sip }:

buildPythonPackage {
  pname = "libsavitar-lulzbot";
  name = "libsavitar-lulzbot";
  version = "3.6.18";
  format = "other";

  src = fetchgit {
    url = https://code.alephobjects.com/source/savitar.git;
    rev = "988a26d35b2a1d042f8c38938ccda77ab146af7d";
    sha256 = "146agw3a92azkgs5ahmn2rrck4an78m2r3pcss6ihmb60lx165k7";
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
