{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdb";
  version = "20251021";

  src = fetchurl {
    url = "https://cdb.cr.yp.to/cdb-${finalAttrs.version}.tar.gz";
    hash = "sha256-jlMdY5C818mky9Fv7TYybu546LDlwHg6gVimp5Q3490=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  patches = [
    # disable chmod on output directories
    ./disable-chmod-dirs.patch
  ];

  postPatch = ''
    # Don't hardcode gcc
    substituteInPlace conf-cc conf-ld --replace-fail 'gcc' '${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc'
  '';

  configurePhase = ''
    runHook preConfigure

    # Set install prefix to output directory
    echo "$out" > conf-home

    runHook postConfigure
  '';

  postInstall = ''
    mkdir -p $man/share/man/man1 $man/share/man/man3
    cp doc/man/*.1 $man/share/man/man1/
    cp doc/man/*.3 $man/share/man/man3/

    mkdir -p $doc/share/doc/cdb
    cp doc/*.md $doc/share/doc/cdb/
    cp -r doc/html $doc/share/doc/cdb/
  '';

  meta = {
    homepage = "https://cdb.cr.yp.to/";
    license = lib.licenses.publicDomain;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
