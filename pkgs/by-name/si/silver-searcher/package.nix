{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  pcre,
  zlib,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "silver-searcher";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ggreer";
    repo = "the_silver_searcher";
    rev = finalAttrs.version;
    sha256 = "0cyazh7a66pgcabijd27xnk1alhsccywivv6yihw378dqxb22i1p";
  };

  patches = [ ./bash-completion.patch ];

  env = {
    # Workaround build failure on -fno-common toolchains like upstream
    # gcc-10. Otherwise build fails as:
    #   ld: src/zfile.o:/build/source/src/log.h:12: multiple definition of
    #     `print_mtx'; src/ignore.o:/build/source/src/log.h:12: first defined here
    # TODO: remove once next release has https://github.com/ggreer/the_silver_searcher/pull/1377
    NIX_CFLAGS_COMPILE = "-fcommon";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_LDFLAGS = "-lgcc_s";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    pcre
    zlib
    xz
  ];

  meta = {
    homepage = "https://github.com/ggreer/the_silver_searcher/";
    description = "Code-searching tool similar to ack, but faster";
    maintainers = with lib.maintainers; [ madjar ];
    mainProgram = "ag";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
  };
})
