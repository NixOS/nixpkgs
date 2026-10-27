{
  lib,
  stdenv,
  fetchurl,
  bash,
  bison,
  flex,
  gperf,
  ncurses,
  pkg-config,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kconfig-frontends";
  version = "4.11.0.1";

  src = fetchurl {
    url = "https://bitbucket.org/nuttx/tools/downloads/kconfig-frontends-${finalAttrs.version}.tar.bz2";
    hash = "sha256-yxg4z+Lwl7oJyt4n1HUncg1bKeK3FcCpbDPQtqELqxM=";
  };

  patches = [
    # This patch is a fixed file, there is no need to normalize it
    (fetchurl {
      url = "https://bitbucket.org/nuttx/tools/downloads/gperf3.1_kconfig_id_lookup.patch";
      hash = "sha256-cqAWjRnMA/fJ8wnEfUxoPEW0hIJY/mprE6/TQMY6NPI=";
    })
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    bison
    flex
    gperf
    pkg-config
  ];

  buildInputs = [
    bash
    ncurses
    python3
  ];

  strictDeps = true;

  configureFlags = [
    "--enable-frontends=conf,mconf,nconf"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=format-security";

  meta = {
    description = "Out of Linux tree packaging of the kconfig infrastructure";
    longDescription = ''
      Configuration language and system for the Linux kernel and other
      projects. Features simple syntax and grammar, limited yet adequate option
      types, simple organization of options, and direct and reverse
      dependencies.
    '';
    homepage = "https://bitbucket.org/nuttx/tools/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
