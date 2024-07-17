{
  lib,
  stdenv,
  fetchurl,
  sndio,
  libbsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aucatctl";
  version = "0.1";

  src = fetchurl {
    url = "http://www.sndio.org/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "524f2fae47db785234f166551520d9605b9a27551ca438bd807e3509ce246cf0";
  };

  buildInputs = [ sndio ] ++ lib.optional (!stdenv.isDarwin && !stdenv.hostPlatform.isBSD) libbsd;

  outputs = [
    "out"
    "man"
  ];

  preBuild =
    ''
      makeFlagsArray+=("PREFIX=$out")
    ''
    + lib.optionalString (!stdenv.isDarwin && !stdenv.hostPlatform.isBSD) ''
      makeFlagsArray+=(LDADD="-lsndio -lbsd")

      # Fix warning about implicit declaration of function 'strlcpy'
      substituteInPlace aucatctl.c \
        --replace '#include <string.h>' '#include <bsd/string.h>'
    '';

  meta = with lib; {
    description = "The aucatctl utility sends MIDI messages to control sndiod and/or aucat volumes";
    homepage = "http://www.sndio.org";
    license = licenses.isc;
    maintainers = with maintainers; [ sna ];
    platforms = platforms.unix;
    mainProgram = "aucatctl";
  };
})
