{ lib, stdenv, fetchFromGitHub, fetchpatch
, guile, pkg-config, glib, loudmouth, gmp, libidn, readline, libtool
, libunwind, ncurses, curl, jansson, texinfo
, automake, autoconf }:
stdenv.mkDerivation rec {
  pname = "freetalk";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "GNUFreetalk";
    repo = "freetalk";
    rev = "v${version}";
    sha256 = "09jwk2i8qd8c7wrn9xbqcwm32720dwxis22kf3jpbg8mn6w6i757";
  };

  patches = [
    # Pull pending patch for -fno-common tuulchain support:
    #   https://github.com/GNUFreetalk/freetalk/pull/39
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/GNUFreetalk/freetalk/commit/f04d6bc8422be44cdf51b29c9a4310f20a18775a.patch";
      sha256 = "1zjm56cdibnqabgcwl2bx79dj6dmqjf40zghqwwb0lfi60v1njqf";
    })
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ pkg-config texinfo autoconf automake ];
  buildInputs = [
    guile glib loudmouth gmp libidn readline libtool
    libunwind ncurses curl jansson
  ];

  meta = with lib; {
    description =  "Console XMPP client";
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    downloadPage = "https://www.gnu.org/software/freetalk/";
  };
}
