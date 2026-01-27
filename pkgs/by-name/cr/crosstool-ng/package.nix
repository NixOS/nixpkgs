{
  lib,
  stdenv,
  fetchurl,
  binutils,
  bison,
  flex,
  help2man,
  libtool,
  makeWrapper,
  ncurses,
  automake,
  autoconf,
  python3,
  texinfo,
  unzip,
  wget,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crosstool-ng";
  version = "1.28.0";

  src = fetchurl {
    url = "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${finalAttrs.version}.tar.xz";
    hash = "sha256-V1DimivaXNjWeQBZJXaxZwoZh6Tc1eT2vq4JE4ofVpk=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    binutils
    bison
    flex
    help2man
    libtool
    makeWrapper
    ncurses
    python3
    texinfo
    unzip
    wget
    which
  ];

  preConfigure = ''
    patchShebangs .
    ./bootstrap
  '';

  # binutils interfere with code signing on darwin
  dontStrip = stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://crosstool-ng.github.io/";
    description = "Versatile (cross-)toolchain generator";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      jiegec
      cilki
    ];
    platforms = lib.platforms.unix;
  };
})
