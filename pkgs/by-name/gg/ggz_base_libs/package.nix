{
  lib,
  stdenv,
  fetchurl,
  intltool,
  openssl,
  expat,
  libgcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ggz-base-libs";
  version = "0.99.5";

  src = fetchurl {
    url = "https://mirrors.ibiblio.org/pub/mirrors/ggzgamingzone/ggz/snapshots/ggz-base-libs-snapshot-${finalAttrs.version}.tar.gz";
    hash = "sha256-sy2uhOpH2237jbriT7IPzHG5WOotfvue/2bI5cDbgbM=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace-fail "/usr/local/ssl/include" "${openssl.dev}/include" \
      --replace-fail "/usr/local/ssl/lib" "${lib.getLib openssl}/lib"
  '';

  nativeBuildInputs = [ intltool ];
  buildInputs = [
    openssl
    expat
    libgcrypt
  ];

  # gcc 15 errors on incompatible-pointer-types (ggz_tls_openssl.c OPENSSL_sk_* casts) and implicit-function-declaration (configure C99 VLA probe).
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=implicit-function-declaration"
  ];

  configureFlags = [
    "--with-tls"
  ];

  meta = {
    description = "GGZ Gaming zone libraries";
    mainProgram = "ggz-config";
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    downloadPage = "http://www.ggzgamingzone.org/releases/";
  };
})
