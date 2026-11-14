{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  pkg-config,
  boost,
  openssl,
  log4shib,
  xercesc,
  xml-security-c,
  xml-tooling-c,
  zlib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensaml-cpp";
  version = "3.3.1";

  outputs = [
    "out"
    "bin"
    "dev"
    "doc"
  ];

  src = fetchFromCodeberg {
    owner = "Shibboleth";
    repo = "cpp-opensaml";
    tag = finalAttrs.version;
    hash = "sha256-/9ba1/fBc1pVleGswb/UBs6bcnu1oEUb+tu+5NN9IJM=";
  };

  buildInputs = [
    boost
    openssl
    log4shib
    xercesc
    xml-security-c
    xml-tooling-c
    zlib
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  # Uses C++ features removed from libc++ in C++17 (auto_ptr, binders).
  # clang rejects -std=c++14 on C sources, so Darwin passes it to C++ only.
  env =
    if stdenv.hostPlatform.isDarwin then
      { CXXFLAGS = "-std=c++14"; }
    else
      { NIX_CFLAGS_COMPILE = "-std=c++14"; };

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://shibboleth.net/products/opensaml-cpp.html";
    description = "Low-level library written in C++ that provides support for producing and consuming SAML messages";
    mainProgram = "samlsign";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
