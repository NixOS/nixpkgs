{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  bison,
  flex,
  libsepol,
  libselinux,
  bzip2,
  audit,
  enablePython ? true,
  swig ? null,
  python3 ? null,
}:

stdenv.mkDerivation rec {
  pname = "libsemanage";
  version = "3.8.1";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/libsemanage-${version}.tar.gz";
    sha256 = "sha256-ezkSeyGcxwv9k1pK9rDyuoPUs1yRbyU8fpQsI6tJDwc=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ]
  ++ lib.optional enablePython "py";

  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ]
  ++ lib.optionals enablePython [
    python3
    swig
  ];

  buildInputs = [
    libsepol
    libselinux
    bzip2
    audit
  ]
  ++ lib.optional enablePython python3;

  makeFlags = [
    "PREFIX=$(out)"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN5DIR=$(man)/share/man/man5"
    "PYTHON=python"
    "PYPREFIX=python"
    "PYTHONLIBDIR=$(py)/${python3.sitePackages}"
    "DEFAULT_SEMANAGE_CONF_LOCATION=$(out)/etc/selinux/semanage.conf"
  ];

  # The following turns the 'clobbered' error into a warning
  # which should fix the following error:
  #
  # semanage_store.c: In function 'semanage_exec_prog':
  # semanage_store.c:1278:6: error: variable 'i' might be clobbered by 'longjmp' or 'vfork' [8;;https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wclobbered-Werror=clobbered8;;]
  #  1278 |  int i;
  #       |      ^
  # cc1: all warnings being treated as errors
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=clobbered" ];

  installTargets = [ "install" ] ++ lib.optionals enablePython [ "install-pywrap" ];

  enableParallelBuilding = true;

  meta = removeAttrs libsepol.meta [ "outputsToInstall" ] // {
    description = "Policy management tools for SELinux";
    license = lib.licenses.lgpl21;
  };
}
