{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  libtool,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libretls";
  version = "3.8.1";

  src = fetchgit {
    url = "https://git.causal.agency/libretls";
    tag = finalAttrs.version;
    hash = "sha256-cFu9v8vOkfvIj/OfD0Er3n+gbH1h1CHOHA6a0pJuwXY=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libtool
  ];

  autoreconfFlags = [
    "--force"
    "--install"
  ];

  buildInputs = [ openssl ];

  strictDeps = true;

  meta = {
    description = "Libtls for OpenSSL";
    homepage = "https://git.causal.agency/libretls/about/";
    changelog = "https://git.causal.agency/libretls/tag/?h=${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ mtrsk ];
  };
})
