{
  lib,
  stdenv,
  gcc14Stdenv,
  fetchFromGitHub,
  libpq,
  python3,
  postgresql,
  postgresqlTestHook,
  autoreconfHook,
}:

# Work around issue reported in https://github.com/NixOS/nixpkgs/issues/476278.
# Should be solved when libpqxx 8.x is released.
gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "libpqxx";
  version = "7.10.5";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = finalAttrs.version;
    hash = "sha256-QlzP/4ze9PFdadkcCxppVeOAKYGscrc4Db52xHcbPIA=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    # Needed because Makefile.am is patched to disable the tools/lint test.
    autoreconfHook
    python3
  ];

  buildInputs = [
    libpq
  ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  postPatch = ''
    # Disable linting step for tests, it tries to install packages with pip.
    substituteInPlace Makefile.am \
      --replace-fail "TESTS = tools/lint" ""

    patchShebangs ./tools/splitconfig.py
    # Needed for autoreconfHook
    patchShebangs tools/*.py
  '';

  configureFlags = [
    "--disable-documentation"
    "--enable-shared"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  __structuredAttrs = true;

  strictDeps = true;

  meta = {
    changelog = "https://github.com/jtv/libpqxx/releases/tag/${finalAttrs.version}";
    description = "C++ library to access PostgreSQL databases";
    downloadPage = "https://github.com/jtv/libpqxx";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
