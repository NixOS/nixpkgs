{ stdenv, fetchFromGitHub, asciidoc, libxcb, xcbutil, xcbutilkeysyms
, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "sxhkd-${version}";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sxhkd";
    rev = version;
    sha256 = "0cw547x7vky55k3ksrmzmrra4zhslqcwq9xw0y4cmbvy4s1qf64v";
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
