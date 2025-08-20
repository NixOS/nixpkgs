{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpqxx";
  version = "7.9.2";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = finalAttrs.version;
    hash = "sha256-I5e0iqXlZqDOMa1PlnrxpcKt1c2mbnSbVQrpi1Gh25o=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    postgresql.dev
    python3
  ];

  buildInputs = [
    postgresql.lib
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
