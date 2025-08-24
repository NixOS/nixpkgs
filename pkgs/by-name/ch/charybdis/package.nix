{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoreconfHook,
  bison,
  flex,
  openssl,
  gnutls,
}:

stdenv.mkDerivation rec {
  pname = "charybdis";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "charybdis-ircd";
    repo = "charybdis";
    rev = "${pname}-${version}";
    sha256 = "1lndk0yp27qm8bds4jd204ynxcq92fqmpfb0kkcla5zgky3miks3";
  };

  patches = [
    (fetchurl {
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/d13eb723d7e9512fb2f2516e5934bd927a92eb2c/community/charybdis/fix-missing-include.patch";
      hash = "sha256-8JXYuIjoHQg+l33OjseF5nnd5ZPagBA2/bSa3Il5Te4=";
    })
  ];

  postPatch = ''
    substituteInPlace include/defaults.h --replace 'PKGLOCALSTATEDIR "' '"/var/lib/charybdis'
    substituteInPlace include/defaults.h --replace 'ETCPATH "' '"/etc/charybdis'
  '';

  autoreconfPhase = "sh autogen.sh";

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl.dev}"
    "--with-program-prefix=charybdis-"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];
  buildInputs = [
    openssl
    gnutls
  ];

  meta = with lib; {
    description = "IRCv3 server designed to be highly scalable";
    homepage = "https://github.com/charybdis-ircd/charybdis";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lassulus ];
    platforms = platforms.unix;
  };

}
