{
  lib,
  stdenv,
  fetchFromCodeberg,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.3.113";
  pname = "libaio";

  src = fetchFromCodeberg {
    owner = "jmoyer";
    repo = "libaio";
    tag = "libaio-${finalAttrs.version}";
    hash = "sha256-8TofYbwsnenv5GuC6FjkUt9rBTULEb5nhknuxr2ckQg=";
  };

  postPatch = ''
    patchShebangs harness

    # Makefile is too optimistic, gcc is too smart
    substituteInPlace harness/Makefile \
      --replace "-Werror" ""
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
  ]
  ++ lib.optional stdenv.hostPlatform.isStatic "ENABLE_SHARED=0";

  hardeningDisable = lib.optional (stdenv.hostPlatform.isi686) "stackprotector";

  checkTarget = "partcheck"; # "check" needs root

  meta = {
    description = "Library for asynchronous I/O in Linux";
    homepage = "https://lse.sourceforge.net/io/aio.html";
    downloadPage = "https://codeberg.org/jmoyer/libaio";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
})
