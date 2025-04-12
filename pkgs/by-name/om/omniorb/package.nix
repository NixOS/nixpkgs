{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {

  pname = "omniorb";
  version = "4.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
    hash = "sha256-HHRTMNAZBK/Xoe0KWJa5puU6waS4ZKSFA7k8fuy/H6g=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ python3 ];

  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  # Transform omniidl_be into a PEP420 namespace to allow other projects to define
  # their omniidl backends. Especially useful for omniorbpy, the python backend.
  postInstall = ''
    rm $out/${python3.sitePackages}/omniidl_be/__init__.py
    rm $out/${python3.sitePackages}/omniidl_be/__pycache__/__init__.*.pyc
  '';

  # Ensure postInstall didn't break cxx backend
  # Same as 'pythonImportsCheck = ["omniidl_be.cxx"];', but outside buildPythonPackage
  doInstallCheck = true;
  postInstallCheck = ''
    export PYTHONPATH=$out/${python3.sitePackages}:$PYTHONPATH
    ${lib.getExe python3} -c "import omniidl_be.cxx"
  '';

  meta = with lib; {
    description = "Robust high performance CORBA ORB for C++ and Python";
    longDescription = ''
      omniORB is a robust high performance CORBA ORB for C++ and Python.
      It is freely available under the terms of the GNU Lesser General Public License
      (for the libraries),and GNU General Public License (for the tools).
      omniORB is largely CORBA 2.6 compliant.
    '';
    homepage = "http://omniorb.sourceforge.net/";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with maintainers; [ smironov ];
    platforms = platforms.unix;
  };
}
