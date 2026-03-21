{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  nodejs,
  libelf,
  libunwind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "malt";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "memtt";
    repo = "malt";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4lCAEk/b8APuOo+x/kGSTg7vFSBZf/VBuSMDM7o5sts=";
  };

  postPatch = ''
    sed -i s,@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@,@CMAKE_INSTALL_LIBDIR@, \
      src/integration/malt.sh.in
    sed -i -e 's,^NODE=""$,NODE=${nodejs}/bin/node,' -e s,^detectNodeJS$,, \
      src/integration/malt-{webview,passwd}.sh.in
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_JEMALLOC" false)
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libelf
    libunwind
  ];

  meta = {
    description = "Memory tool to find where you allocate your memory";
    homepage = "https://github.com/memtt/malt";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [ skohtv ];
    platforms = lib.platforms.linux;
  };
})
