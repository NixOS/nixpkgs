{
  lib,
  stdenv,
  fetchurl,
  libnetfilter_conntrack,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iptstate";
  version = "2.2.7";

  src = fetchurl {
    url = "https://github.com/jaymzh/iptstate/releases/download/v${finalAttrs.version}/iptstate-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-iW3wYCiFRWomMfeV1jT8ITEeUF+MkQNI5jEoYPIJeVU=";
  };

  buildInputs = [
    libnetfilter_conntrack
    ncurses
  ];

  meta = {
    description = "Conntrack top like tool";
    mainProgram = "iptstate";
    homepage = "https://github.com/jaymzh/iptstate";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ trevorj ];
    downloadPage = "https://github.com/jaymzh/iptstate/releases";
    license = lib.licenses.zlib;
  };

  installPhase = ''
    install -m755 -D iptstate $out/bin/iptstate
  '';
})
