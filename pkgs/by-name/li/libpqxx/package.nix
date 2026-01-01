{
  lib,
  stdenv,
  fetchFromGitHub,
  libpq,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpqxx";
<<<<<<< HEAD
  version = "7.10.4";
=======
  version = "7.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-0/gkfoJg+Zt9LLLQ/TVkUhBZ3NYIzg+uIClU89ORr+4=";
=======
    hash = "sha256-BVmIyJA5gDibwtmDvw7b300D0KdWv7c3Ytye6fiLAXU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
