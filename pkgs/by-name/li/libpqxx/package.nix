{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpqxx";
  version = "7.7.5";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = finalAttrs.version;
    hash = "sha256-mvGPMbk4b8NmPvzy5hS+Au69NtDGha8ONTEQf6I3VZE=";
  };

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [
    postgresql
  ];

  preConfigure = ''
    patchShebangs ./tools/splitconfig
  '';

  configureFlags = [
    "--enable-shared --disable-documentation"
  ];
  CXXFLAGS = [
    "-std=c++17"
  ];

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
