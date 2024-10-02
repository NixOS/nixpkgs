{
  fetchFromGitHub,
  lib,
  postgresql,
  python3,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "7.9.2";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = version;
    hash = "sha256-I5e0iqXlZqDOMa1PlnrxpcKt1c2mbnSbVQrpi1Gh25o=";
  };

  outputs = [
    "dev"
    "out"
  ];

  postPatch = ''
    patchShebangs ./tools/splitconfig.py
  '';

  configureFlags = [
    "--disable-documentation"
    "--enable-shared"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    postgresql.dev
    python3
  ];

  buildInputs = [
    postgresql.lib
  ];

  meta = {
    description = "C++ library to access PostgreSQL databases";
    downloadPage = "https://github.com/jtv/libpqxx";
    changelog = "https://github.com/jtv/libpqxx/releases/tag/${version}";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
