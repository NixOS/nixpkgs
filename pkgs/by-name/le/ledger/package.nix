{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  boost,
  gmp,
  mpfr,
  libedit,
  python3,
  gpgme,
  installShellFiles,
  texinfo,
  gnused,
  usePython ? false,
  gpgmeSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "ledger";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "ledger";
    repo = "ledger";
    rev = "v${version}";
    hash = "sha256-Uym4s8EyzXHlISZqThcb6P1H5bdgD9vmdIOLkk5ikG0=";
  };

  patches = [
    (fetchpatch2 {
      name = "ledger-boost-1.85-compat.patch";
      url = "https://github.com/ledger/ledger/commit/46207852174feb5c76c7ab894bc13b4f388bf501.patch";
      hash = "sha256-X0NSN60sEFLvcfMmtVoxC7fidcr5tJUlFVQ/E8qfLss=";
    })
    (fetchpatch2 {
      name = "ledger-boost-1.86-compat-1.patch";
      url = "https://github.com/ledger/ledger/commit/f6750ed89b46926d1f0859f3b25d18ed62ac219e.patch";
      hash = "sha256-pktwotuMbZcR2DpZccMqV13524avKvazDX/+Ki6h69g=";
    })
    (fetchpatch2 {
      name = "ledger-boost-1.86-compat-2.patch";
      url = "https://github.com/ledger/ledger/commit/62f626fa73bd6832028f43c204c43cf15bd5f409.patch";
      hash = "sha256-cazhSxadNpiA6ofZxS8JALOPy88cNPM/jKHaUYk8pBw=";
    })
    (fetchpatch2 {
      name = "ledger-boost-1.86-compat-3.patch";
      url = "https://github.com/ledger/ledger/commit/124398c35be573324cf2384c08b99b4476f29e2b.patch";
      hash = "sha256-N3dUrqNsOiVgedoYmyfYllK+4lvKdMxc8iq0+DgEbxc=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals usePython [ "py" ];

  buildInputs = [
    gmp
    mpfr
    libedit
    gnused
  ]
  ++ lib.optionals gpgmeSupport [
    gpgme
  ]
  ++ (
    if usePython then
      [
        python3
        (boost.override {
          enablePython = true;
          python = python3;
        })
      ]
    else
      [ boost ]
  );

  nativeBuildInputs = [
    cmake
    texinfo
    installShellFiles
  ];

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

  installTargets = [
    "doc"
    "install"
  ];

  postInstall = ''
    installShellCompletion --cmd ledger --bash $src/contrib/ledger-completion.bash
  '';

  meta = {
    description = "Double-entry accounting system with a command-line reporting interface";
    mainProgram = "ledger";
    homepage = "https://www.ledger-cli.org/";
    changelog = "https://github.com/ledger/ledger/raw/v${version}/NEWS.md";
    license = lib.licenses.bsd3;
    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jwiegley ];
  };
}
