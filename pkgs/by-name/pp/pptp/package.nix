{
  lib,
  stdenv,
  fetchurl,
  perl,
  ppp,
  iproute2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pptp";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/pptpclient/pptp-${finalAttrs.version}.tar.gz";
    sha256 = "1x2szfp96w7cag2rcvkdqbsl836ja5148zzfhaqp7kl7wjw2sjc2";
  };

  prePatch = ''
    substituteInPlace Makefile --replace 'install -o root' 'install'
  '';

  makeFlags = [
    "CC:=$(CC)"
    "IP=${iproute2}/bin/ip"
    "PPPD=${ppp}/bin/pppd"
    "BINDIR=${placeholder "out"}/sbin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "PPPDIR=${placeholder "out"}/etc/ppp"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    perl # pod2man
  ];

  buildInputs = [
    perl # in shebang of pptpsetup
  ];

  meta = {
    description = "PPTP client for Linux";
    homepage = "https://pptpclient.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
