{
  lib,
  stdenv,
  fetchurl,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcre2";
  version = "10.48";

  src = fetchurl {
    url = "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${finalAttrs.version}/pcre2-${finalAttrs.version}.tar.bz2";
    hash = "sha256-tsaP3286wxOItQqon/D8ScAMmHwW57UUZJHRIAPyyO0=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    # only enable jit on supported platforms which excludes Apple Silicon, see https://github.com/zherczeg/sljit/issues/51
    "--enable-jit=${if stdenv.hostPlatform.isS390x then "no" else "auto"}"
  ];

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
    "man"
    "devdoc"
  ];

  postFixup = ''
    moveToOutput bin/pcre2-config "$dev"
  '';

  meta = {
    homepage = "https://www.pcre.org/";
    changelog = "https://github.com/PCRE2Project/pcre2/releases/tag/pcre2-${finalAttrs.version}";
    description = "Perl Compatible Regular Expressions";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "libpcre2-posix"
      "libpcre2-8"
      "libpcre2-16"
      "libpcre2-32"
    ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "pcre" finalAttrs.version;
  };
})
