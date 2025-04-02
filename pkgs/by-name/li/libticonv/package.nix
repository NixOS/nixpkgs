{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libticonv";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "debrouxl";
    repo = "tilibs";
    rev = "aae5bcf4a6b7c653eaf1d80c752e74eff042b4b5";
    hash = "sha256-W2SkOsqm3HJ3z6RHua5LQW6Mq1VQHGcouz0Cu/zENJE=";
  };

  sourceRoot = finalAttrs.src.name + "/libticonv/trunk";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  configureFlags = [
    "--enable-iconv"
  ] ++ lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS=-liconv";

  meta = with lib; {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "This library is part of the TiLP framework";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      siraben
      clevor
    ];
    platforms = with platforms; linux ++ darwin;
  };
})
