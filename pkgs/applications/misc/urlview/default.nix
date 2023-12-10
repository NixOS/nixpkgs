{ lib, stdenv, fetchurl, ncurses, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "urlview";
  _version    = "0.9";
  patchLevel = "19";
  version = "${_version}-${patchLevel}";

  urlBase = "mirror://debian/pool/main/u/urlview/";

  src = fetchurl {
    url = urlBase + "urlview_${_version}.orig.tar.gz";
    sha256 = "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ];

  # urlview appears to be unmaintained
  # https://salsa.debian.org/debian/urlview/-/commit/4ad7d236c745b665db1d2fd07ce5ffc1748e4240
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-implicit-function-declaration"
      "-Wno-parentheses"
      "-Wno-pointer-sign"
      "-Wno-unknown-escape-sequence"
    ];
  };

  preAutoreconf = ''
    touch NEWS
  '';

  preConfigure = ''
    mkdir -p $out/share/man/man1
  '';

  debianPatches = fetchurl {
    url = urlBase + "urlview_${_version}-${patchLevel}.diff.gz";
    sha256 = "056883c17756f849fb9235596d274fbc5bc0d944fcc072bdbb13d1e828301585";
  };

  patches = debianPatches;

  postPatch = ''
    substituteInPlace urlview.c \
      --replace '/etc/urlview/url_handler.sh' "$out/etc/urlview/url_handler.sh"
  '';

  postInstall = ''
    install -Dm755 url_handler.sh $out/etc/urlview/url_handler.sh
    patchShebangs $out/etc/urlview
  '';

  meta = with lib; {
    description = "Extract URLs from text";
    homepage = "https://packages.qa.debian.org/u/urlview.html";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ ma27 ];
  };
}
