{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netcat-gnu";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/netcat/netcat-${finalAttrs.version}.tar.bz2";
    hash = "sha256:1frjcdkhkpzk0f84hx6hmw5l0ynpmji8vcbaxg8h5k2svyxz0nmm";
  };

  meta = {
    description = "Utility which reads and writes data across network connections";
    homepage = "https://netcat.sourceforge.net/";
    mainProgram = "netcat";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
})
