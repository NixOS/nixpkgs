{
  lib,
  stdenv,
  fetchurl,
  omniorb,
  pkg-config,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omniorbpy";
  version = "4.3.2";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/omniorb/omniORBpy-${finalAttrs.version}.tar.bz2";
    hash = "sha256-y1cX1BKhAbr0MPWYysfWkjGITa5DctjirfPd7rxffrs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    omniorb
  ];

  configureFlags = [
    "--with-omniorb=${omniorb}"
    "PYTHON_PREFIX=$out"
    "PYTHON=${lib.getExe python3}"
  ];

  # Transform omniidl_be into a PEP420 namespace
  postInstall = ''
    rm $out/${python3.sitePackages}/omniidl_be/__init__.py
    rm $out/${python3.sitePackages}/omniidl_be/__pycache__/__init__.*.pyc
  '';

  # Ensure both python & cxx backends are available
  doInstallCheck = true;
  postInstallCheck = ''
    export PYTHONPATH=$out/${python3.sitePackages}:${omniorb}/${python3.sitePackages}:$PYTHONPATH
    ${lib.getExe python3} -c "import omniidl_be.cxx; import omniidl_be.python"
  '';


  meta = with lib; {
    description = "The python backend for omniorb";
    homepage = "http://omniorb.sourceforge.net";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix;
  };
})
