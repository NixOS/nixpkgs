{ stdenv, lib, fetchFromGitHub, cmake, boost, gmp, mpfr, libedit, python
, texinfo, gnused, usePython ? true }:

stdenv.mkDerivation rec {
  pname = "ledger";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner  = "ledger";
    repo   = "ledger";
    rev    = "v${version}";
    sha256 = "0x6jxwss3wwzbzlwmnwb8yzjk8f9wfawif4f1b74z2qg6hc4r7f6";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    (boost.override { enablePython = usePython; })
    gmp mpfr libedit python gnused
  ];

  nativeBuildInputs = [ cmake texinfo ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_DOCS:BOOL=ON"
    (lib.optionalString usePython "-DUSE_PYTHON=true")
  ] ++ lib.optionals (usePython && stdenv.isDarwin) [
    # Fix python lookup on Darwin. Not necessary after
    # https://github.com/NixOS/nixpkgs/pull/94090 lands in master
    "-DPython_ROOT_DIR=${python}"
  ];

  # by default, it will query the python interpreter for it's sitepackages location
  # however, that would write to a different nixstore path, pass our own sitePackages location
  prePatch = lib.optionalString usePython ''
    substituteInPlace src/CMakeLists.txt \
      --replace 'DESTINATION ''${Python_SITEARCH}' 'DESTINATION "${python.sitePackages}"'
  '';

  installTargets = [ "doc" "install" ];

  meta = with lib; {
    homepage = "https://ledger-cli.org/";
    description = "A double-entry accounting system with a command-line reporting interface";
    license = licenses.bsd3;

    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';

    platforms = platforms.all;
    maintainers = with maintainers; [ jwiegley ];
  };
}
