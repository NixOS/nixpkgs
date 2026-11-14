{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  bison,
  m4,
  autoreconfHook,
  help2man,
}:

# Avoid 'fetchpatch' to allow 'flex' to be used as a possible 'gcc'
# dependency during bootstrap. Useful when gcc is built from snapshot
# or from a git tree (flex lexers are not pre-generated there).

stdenv.mkDerivation (finalAttrs: {
  pname = "flex";
  version = "2.6.9";

  src = fetchurl {
    url = "https://github.com/westes/flex/releases/download/v${finalAttrs.version}/flex-${finalAttrs.version}.tar.gz";
    hash = "sha256-CLzvkBfbdSJGU2BiY0Gi7s8SaLkw6b5B2fHg4lS1W+s=";
  };

  postPatch = ''
    patchShebangs tests
  ''
  + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace Makefile.in --replace-fail "tests" " "

    substituteInPlace doc/Makefile.am --replace-fail 'flex.1: $(top_srcdir)/configure.ac' 'flex.1: '
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook
    help2man
  ];
  buildInputs = [ bison ];
  propagatedBuildInputs = [ m4 ];

  strictDeps = true;

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    export ac_cv_func_malloc_0_nonnull=yes
    export ac_cv_func_realloc_0_nonnull=yes
  '';

  postConfigure = lib.optionalString (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isCygwin) ''
    sed -i Makefile -e 's/-no-undefined//;'
  '';

  dontDisableStatic = stdenv.buildPlatform != stdenv.hostPlatform;

  postInstall = ''
    ln -s $out/bin/flex $out/bin/lex
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/westes/flex";
    description = "Fast lexical analyser generator";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
