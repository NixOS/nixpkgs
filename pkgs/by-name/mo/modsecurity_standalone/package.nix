{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  curl,
  apacheHttpd,
  pcre,
  apr,
  aprutil,
  libxml2,
  luaSupport ? false,
  lua5,
  perl,
  fetchpatch,
  versionCheckHook,
}:

let
  luaValue = if luaSupport then lua5 else "no";
  optional = lib.optional;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "modsecurity";
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = "modsecurity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fJ5XeO5m5LlImAuzIvXVVWkc9awbaRI3NWWOOwGrshI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    curl
    apacheHttpd
    pcre
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
    "--with-pcre=${pcre.dev}"
    "--with-apr=${apr.dev}"
    "--with-apu=${aprutil.dev}/bin/apu-1-config"
    "--with-libxml=${libxml2.dev}"
    "--with-lua=${luaValue}"
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    # msc_test.c:86:5: error: initialization of 'int' from 'void *' makes integer from pointer without a cast []
    "-Wno-error=int-conversion"
  ];

  outputs = [
    "out"
    "nginx"
  ];
  patches = [
    # by default modsecurity's install script copies compiled output to httpd's modules folder
    # this patch removes those lines
    ./Makefile.am.patch
    # remove when 2.9.9 is released
    (fetchpatch {
      name = "move-id_log";
      url = "https://github.com/owasp-modsecurity/ModSecurity/commit/149376377ecef9ecc36ee81d5b666fc0ac7e249b.patch";
      hash = "sha256-KjQGqSBt/u9zPZY1aSIupnYHleJbsOAOk3Y2bNOyRxk=";
    })
    # remove when 2.9.9 is released
    (fetchpatch {
      name = "gcc-format-security";
      url = "https://github.com/owasp-modsecurity/ModSecurity/commit/cddd9a7eb5585a9b3be1f9bdcadcace8f60f5808.patch";
      hash = "sha256-H1wkZQ5bTQIRhlEvvvj7YCBi9qndRgHgKTnE9Cusq3I=";
    })
    # remove when 2.9.9 is released
    (fetchpatch {
      name = "gcc-incompatible-pointer-type";
      url = "https://github.com/owasp-modsecurity/ModSecurity/commit/4919814a5cf0e7911f71856ed872b0e73b659a0a.patch";
      hash = "sha256-9JzCtiLf43xw6i4NqQpok37es+kuWXZWKdJum28Hx4M=";
    })
  ];

  doCheck = true;
  nativeCheckInputs = [ perl ];

  postInstall = ''
    mkdir -p $nginx
    cp -R * $nginx
  '';

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
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
