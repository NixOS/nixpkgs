{
  lib,
  stdenv,
  fetchFromGitHub,
  pam,
  bison,
  flex,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
  musl-fts,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libcgroup";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "libcgroup";
    repo = "libcgroup";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-kWW9ID/eYZH0O/Ge8pf3Cso4yu644R5EiQFYfZMcizs=";
  };

  configureFlags = [
    (lib.enableFeature enableSystemd "systemd")
  ]
  # implicit declaration of function 'rpl_malloc', ; did you mean 'realloc'
  #
  # It looks like in case of cross-compilation, autoconf assumes that malloc of the
  # target platform is broken.
  ++ lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];
  buildInputs = [
    pam
  ]
  ++ lib.optional enableSystemd systemdLibs
  ++ lib.optional stdenv.hostPlatform.isMusl musl-fts;

  postPatch = ''
    substituteInPlace src/tools/Makefile.am \
      --replace 'chmod u+s' 'chmod +x'
  '';

  meta = {
    description = "Library and tools to manage Linux cgroups";
    homepage = "https://github.com/libcgroup/libcgroup";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
