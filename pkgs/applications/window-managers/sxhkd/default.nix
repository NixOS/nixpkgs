{ lib, stdenv, fetchFromGitHub, asciidoc, libxcb, xcbutil, xcbutilkeysyms
, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "sxhkd";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sxhkd";
    rev = version;
    sha256 = "1winwzdy9yxvxnrv8gqpigl9y0c2px27mnms62bdilp4x6llrs9r";
  };

  buildInputs = [ asciidoc libxcb xcbutil xcbutilkeysyms xcbutilwm ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple X hotkey daemon";
    homepage = "https://github.com/baskerville/sxhkd";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
