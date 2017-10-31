{ stdenv, fetchFromGitHub, asciidoc, libxcb, xcbutil, xcbutilkeysyms
, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "sxhkd-${version}";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sxhkd";
    rev = version;
    sha256 = "0vnm0d2ckijsp8kc2v8jz4raamb487vg62v58v01a3rb9gzzgl06";
  };

  buildInputs = [ asciidoc libxcb xcbutil xcbutilkeysyms xcbutilwm ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Simple X hotkey daemon";
    homepage = "https://github.com/baskerville/sxhkd";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
