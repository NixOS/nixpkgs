{
  lib,
  stdenv,
  fetchurl,
  sndio,
  libbsd,
}:
let
  isBSDLike = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isBSD;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aucatctl";
  version = "0.1";

  src = fetchurl {
    url = "http://www.sndio.org/aucatctl-${finalAttrs.version}.tar.gz";
    sha256 = "524f2fae47db785234f166551520d9605b9a27551ca438bd807e3509ce246cf0";
  };

  buildInputs = [
    sndio
  ]
  ++ lib.optional (!isBSDLike) libbsd;

  strictDeps = true;

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ]
  ++ lib.optionals (!isBSDLike) [
    "LDADD=-lsndio -lbsd"
  ];

  preBuild = lib.optionalString (!isBSDLike) ''
    # Fix warning about implicit declaration of function 'strlcpy'
    substituteInPlace aucatctl.c \
      --replace-fail '#include <string.h>' '#include <bsd/string.h>'
  '';

  __structuredAttrs = true;

  meta = {
    description = "Utility that allows to send MIDI messages to control sndiod and/or aucat volumes";
    homepage = "http://www.sndio.org";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sna ];
    platforms = lib.platforms.unix;
    mainProgram = "aucatctl";
  };
})
