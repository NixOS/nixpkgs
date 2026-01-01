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
<<<<<<< HEAD
  version = "0.36.0";
=======
  version = "0.35.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "neon";

  src = fetchurl {
    url = "https://notroj.github.io/${pname}/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-cMx/Ku694mOQbhhbJm4E4N6Ss45fTszL9h6LeRd8Lwc=";
=======
    sha256 = "sha256-FGevtz814/XQ6f1wYowUy6Jmpl4qH7bj+UXuM4XIWVs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
