{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "conspy";
  version = "1.16";

  src = fetchurl {
    url = "mirror://sourceforge/project/conspy/conspy-${finalAttrs.version}-1/conspy-${finalAttrs.version}.tar.gz";
    hash = "sha256-7l72SOoI0g2QYtsi579ip7cmGvAgU/kWAW0bgKZqVgk=";
    curlOpts = " -A application/octet-stream ";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [
    ncurses
  ];

  preConfigure = ''
    touch NEWS
    echo "EPL 1.0" > COPYING
    aclocal
    automake --add-missing
    autoconf
  '';

  meta = {
    description = "Linux text console viewer";
    mainProgram = "conspy";
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
  };
})
