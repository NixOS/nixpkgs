{ stdenv, lib, fetchFromGitHub, cmake, boost, gmp, mpfr, libedit, python3
, fetchpatch, installShellFiles, texinfo, gnused, usePython ? true }:

stdenv.mkDerivation rec {
  pname = "ledger";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner  = "ledger";
    repo   = "ledger";
    rev    = "v${version}";
    sha256 = "0x6jxwss3wwzbzlwmnwb8yzjk8f9wfawif4f1b74z2qg6hc4r7f6";
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

  patches = [
    # Add support for $XDG_CONFIG_HOME. Remove with the next release
    (fetchpatch {
      url = "https://github.com/ledger/ledger/commit/c79674649dee7577d6061e3d0776922257520fd0.patch";
      sha256 = "sha256-vwVQnY9EUCXPzhDJ4PSOmQStb9eF6H0yAOiEmL6sAlk=";
      excludes = [ "doc/NEWS.md" ];
    })
  ];

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
