{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  python3,
  pkg-config,
  readline,
  tdb,
  talloc,
  tevent,
  popt,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  cmocka,
  wafHook,
  buildPackages,
  libxcrypt,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ldb";
  version = "2.9.2";

  src = fetchurl {
    url = "mirror://samba/ldb/ldb-${finalAttrs.version}.tar.gz";
    hash = "sha256-0VWIQALHnbscPYZC+LEBPy5SCzru/W6WQSrexbjWy8A=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    python3
    wafHook
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    tdb
    tevent
  ];

  buildInputs = [
    python3
    readline # required to build python
    tdb
    talloc
    tevent
    popt
    cmocka
    libxcrypt
  ];

  patches = [
    # Fix rep_memset_s calling C23 memset_explicit with wrong arg count (4 instead of 3).
    # Upstream samba commit 04e0fb9b2d; later reworked more broadly in ef08be24e9 and 3e81b73a05
    # which replace memset_s with memset_explicit entirely, but those don't apply to ldb 2.9.2.
    (fetchpatch {
      url = "https://gitlab.com/samba-team/samba/-/commit/04e0fb9b2d1d87516f1331096c78e8355b4fa9f3.patch";
      hash = "sha256-sBqtVwGBXseCAMlv3QaiSYQmOw7H4cAJwc0Ey5yD6Os=";
    })
  ];

  # otherwise the configure script fails with
  # PYTHONHASHSEED=1 missing! Don't use waf directly, use ./configure and make!
  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
  '';

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
    "--without-ldb-lmdb"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-compile"
    "--cross-execute=${stdenv.hostPlatform.emulator buildPackages}"
  ];

  env = {
    # python-config from build Python gives incorrect values when cross-compiling.
    # If python-config is not found, the build falls back to using the sysconfig
    # module, which works correctly in all cases.
    PYTHON_CONFIG = "/invalid";
  }
  //
    lib.optionalAttrs (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17")
      {
        # https://reviews.llvm.org/D135402
        NIX_LDFLAGS = "--undefined-version";
      };

  stripDebugList = [
    "bin"
    "lib"
    "modules"
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "LDAP-like embedded database";
    homepage = "https://ldb.samba.org/";
    license = lib.licenses.lgpl3Plus;
    pkgConfigModules = [ "ldb" ];
    platforms = lib.platforms.all;
  };
})
