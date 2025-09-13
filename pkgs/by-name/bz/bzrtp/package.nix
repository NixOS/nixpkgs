{
  bctoolbox,
  cmake,
  fetchFromGitLab,
  sqlite,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bzrtp";
  version = "5.3.72";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "bzrtp";
    rev = finalAttrs.version;
    hash = "sha256-yPwM8W4mc+zLudAS6mQM/buWEGjdYR75NXBkxHQUKK4=";
  };

  buildInputs = [
    bctoolbox
    sqlite
  ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=stringop-overflow"
    "-Wno-error=unused-parameter"
  ];

  meta = with lib; {
    description = "Opensource implementation of ZRTP keys exchange protocol. Part of the Linphone project";
    homepage = "https://gitlab.linphone.org/BC/public/bzrtp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
})
