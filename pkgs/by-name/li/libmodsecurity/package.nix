{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  pkg-config,
  curl,
  geoip,
  libmaxminddb,
  libxml2,
  lmdb,
  lua,
  pcre2,
  ssdeep,
  yajl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmodsecurity";
  version = "3.0.15";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = "ModSecurity";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gI874wkqy8VuwxUmIgb8d7fULJUQ+rKBBF492NtuRMY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    curl
    geoip
    libmaxminddb
    libxml2
    lmdb
    lua
    pcre2
    ssdeep
    yajl
  ];

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    "--enable-parser-generation"
    "--disable-doxygen-doc"
    "--disable-examples"
    "--with-lmdb=${lmdb}"
    "--with-ssdeep=${ssdeep}"
  ];

  postPatch = ''
    # https://github.com/owasp-modsecurity/ModSecurity/blob/v3.0.15/build.sh#L6-L25
    echo "noinst_HEADERS = \\" > ./src/headers.mk
    ls -1 ./src/ \
        actions/*.h \
        actions/ctl/*.h \
        actions/data/*.h \
        actions/disruptive/*.h \
        actions/transformations/*.h \
        debug_log/*.h \
        audit_log/writer/*.h \
        collection/backend/*.h \
        operators/*.h \
        parser/*.h \
        request_body_processor/*.h \
        utils/*.h \
        variables/*.h \
        engine/*.h \
        *.h | tr "\012" " " >> ./src/headers.mk

    substituteInPlace modsecurity.conf-recommended \
      --replace-fail "SecUnicodeMapFile unicode.mapping 20127" "SecUnicodeMapFile $out/share/modsecurity/unicode.mapping 20127"
  '';

  postInstall = ''
    mkdir -p $out/share/modsecurity
    cp ${finalAttrs.src}/{AUTHORS,CHANGES,LICENSE,README.md,modsecurity.conf-recommended,unicode.mapping} $out/share/modsecurity
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    nginx-modsecurity = nixosTests.nginx-modsecurity;
  };

  meta = {
    homepage = "https://github.com/owasp-modsecurity/ModSecurity";
    description = ''
      ModSecurity v3 library component.
    '';
    longDescription = ''
      Libmodsecurity is one component of the ModSecurity v3 project. The
      library codebase serves as an interface to ModSecurity Connectors taking
      in web traffic and applying traditional ModSecurity processing. In
      general, it provides the capability to load/interpret rules written in
      the ModSecurity SecRules format and apply them to HTTP content provided
      by your application via Connectors.
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
    mainProgram = "modsec-rules-check";
  };
})
