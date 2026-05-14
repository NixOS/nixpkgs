{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmodbus";
  version = "3.1.12";

  src = fetchFromGitHub {
    owner = "stephane";
    repo = "libmodbus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DqR0E8ODZFGDx3r92XS+rLRqPD55yOi+NhU0gMRK7KY=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    # when cross-compiling we assume that the host system will return a valid
    # pointer for calls to malloc(0) or realloc(0)
    # https://www.uclibc.org/FAQ.html#gnu_malloc
    # https://www.gnu.org/software/autoconf/manual/autoconf.html#index-AC_005fFUNC_005fMALLOC-454
    # the upstream source should be patched to avoid needing this
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = {
    description = "Library to send/receive data according to the Modbus protocol";
    homepage = "https://libmodbus.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
