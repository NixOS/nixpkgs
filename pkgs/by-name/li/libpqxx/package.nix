{
  lib,
  stdenv,
  gcc14Stdenv,
  fetchFromGitHub,
  libpq,
  python3,
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
    python3
  ];

  buildInputs = [
    libpq
  ];

  postPatch = ''
    patchShebangs ./tools/splitconfig.py
  '';

  configureFlags = [
    "--disable-documentation"
    "--enable-shared"
  ];

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
