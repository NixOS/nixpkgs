{
  lib,
  stdenv,
  fetchurl,
  fixDarwinDylibNames,
  readline,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mujs";
  version = "1.3.6";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${finalAttrs.version}.tar.gz";
    hash = "sha256-fPOl5iLP9BkD7/8DNFGPyUrwYyVnUsOLpGGKUZHkTxg=";
  };

  buildInputs = [ readline ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  makeFlags = [ "prefix=$(out)" ];

  installFlags = [ "install-shared" ];

  passthru.updateScript = gitUpdater {
    # No nicer place to track releases
    url = "git://git.ghostscript.com/mujs.git";
  };

  meta = {
    homepage = "https://mujs.com/";
    description = "Lightweight, embeddable Javascript interpreter";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
    license = lib.licenses.isc;
  };
})
