{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  curl,
  apacheHttpd,
  pcre2,
  apr,
  aprutil,
  libxml2,
  luaSupport ? false,
  lua5,
  perl,
  versionCheckHook,
}:

let
  luaValue = if luaSupport then lua5 else "no";
  optional = lib.optional;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "modsecurity";
  version = "2.9.15";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = "modsecurity";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-gxR4OpY0Z9X0o0Bt3Oq921x1djxIUSCCwdXxI2CmhoM=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    curl
    apacheHttpd
    pcre2
    apr
    aprutil
    libxml2
  ]
  ++ optional luaSupport lua5;

  configureFlags = [
    "--enable-standalone-module"
    "--enable-static"
    "--with-curl=${curl.dev}"
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-pcre2=${lib.getDev pcre2}/bin/pcre2-config"
    "--with-apr=${apr.dev}"
    "--with-apu=${aprutil.dev}/bin/apu-1-config"
    "--with-libxml=${libxml2.dev}"
    "--with-lua=${luaValue}"
  ];

  enableParallelBuilding = true;

  patches = [
    # by default modsecurity's install script copies compiled output to httpd's modules folder
    # this patch removes those lines
    ./Makefile.am.patch
  ];

  doCheck = true;
  nativeCheckInputs = [ perl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-v";
  versionCheckProgram = "${placeholder "out"}/bin/mlogc";

  meta = {
    description = "Open source, cross-platform web application firewall (WAF)";
    license = lib.licenses.asl20;
    homepage = "https://github.com/owasp-modsecurity/ModSecurity";
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
