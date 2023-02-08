{ stdenv, lib, fetchFromGitHub, cmake, boost, gmp, mpfr, libedit, python3
, installShellFiles, texinfo, gnused, usePython ? true }:

stdenv.mkDerivation rec {
  pname = "ledger";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner  = "ledger";
    repo   = "ledger";
    rev    = "v${version}";
    hash   = "sha256-0hN6Hpmgwb3naV2K1fxX0OyH0IyCQAh1nZ9TMNAutic=";
  };

  outputs = [ "out" "dev" "py" ];

  buildInputs = [
    (boost.override { enablePython = usePython; python = python3; })
    gmp mpfr libedit gnused
  ] ++ lib.optional usePython python3;

  nativeBuildInputs = [ cmake texinfo installShellFiles ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_DOCS:BOOL=ON"
    (lib.optionalString usePython "-DUSE_PYTHON=true")
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
    maintainers = with maintainers; [ jwiegley marsam ];
  };
}
