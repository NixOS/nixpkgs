{ stdenv, lib, fetchFromGitHub, cmake, boost, gmp, mpfr, libedit, python3, gpgme
, installShellFiles, texinfo, gnused, usePython ? false, gpgmeSupport ? false }:

stdenv.mkDerivation rec {
  pname = "ledger";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner  = "ledger";
    repo   = "ledger";
    rev    = "v${version}";
    hash   = "sha256-Uym4s8EyzXHlISZqThcb6P1H5bdgD9vmdIOLkk5ikG0=";
  };

  outputs = [ "out" "dev" ] ++ lib.optionals usePython [ "py" ];

  buildInputs = [
    gmp mpfr libedit gnused
  ] ++ lib.optionals gpgmeSupport [
    gpgme
  ] ++ (if usePython
        then [ python3 (boost.override { enablePython = true; python = python3; }) ]
        else [ boost ]);

  nativeBuildInputs = [ cmake texinfo installShellFiles ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_DOCS:BOOL=ON"
    "-DUSE_PYTHON:BOOL=${if usePython then "ON" else "OFF"}"
    "-DUSE_GPGME:BOOL=${if gpgmeSupport then "ON" else "OFF"}"
  ];

  # by default, it will query the python interpreter for it's sitepackages location
  # however, that would write to a different nixstore path, pass our own sitePackages location
  prePatch = lib.optionalString usePython ''
    substituteInPlace src/CMakeLists.txt \
      --replace 'DESTINATION ''${Python_SITEARCH}' 'DESTINATION "${placeholder "py"}/${python3.sitePackages}"'
  '';

  installTargets = [ "doc" "install" ];

  postInstall = ''
    installShellCompletion --cmd ledger --bash $src/contrib/ledger-completion.bash
  '';

  meta = with lib; {
    description = "A double-entry accounting system with a command-line reporting interface";
    homepage = "https://www.ledger-cli.org/";
    changelog = "https://github.com/ledger/ledger/raw/v${version}/NEWS.md";
    license = licenses.bsd3;
    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ jwiegley marsam ];
  };
}
