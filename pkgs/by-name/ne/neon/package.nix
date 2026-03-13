{
  lib,
  stdenv,
  fetchurl,
  libxml2,
  pkg-config,
  compressionSupport ? true,
  zlib ? null,
  sslSupport ? true,
  openssl ? null,
  static ? stdenv.hostPlatform.isStatic,
  shared ? !stdenv.hostPlatform.isStatic,
  bash,
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

let
  inherit (lib) optionals;
in

stdenv.mkDerivation rec {
  version = "0.36.0";
  pname = "neon";

  src = fetchurl {
    url = "https://notroj.github.io/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-cMx/Ku694mOQbhhbJm4E4N6Ss45fTszL9h6LeRd8Lwc=";
  };

  patches = optionals stdenv.hostPlatform.isDarwin [ ./darwin-fix-configure.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxml2
    openssl
    bash
  ]
  ++ lib.optional compressionSupport zlib;

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature shared "shared")
    (lib.enableFeature static "static")
    (lib.withFeature compressionSupport "zlib")
    (lib.withFeature sslSupport "ssl")
  ];

  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  passthru = { inherit compressionSupport sslSupport; };

  meta = {
    description = "HTTP and WebDAV client library";
    mainProgram = "neon-config";
    homepage = "https://notroj.github.io/neon/";
    changelog = "https://github.com/notroj/${pname}/blob/${version}/NEWS";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
}
