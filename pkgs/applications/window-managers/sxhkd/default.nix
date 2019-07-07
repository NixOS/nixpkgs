{ stdenv, fetchFromGitHub, asciidoc, libxcb, xcbutil, xcbutilkeysyms
, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "sxhkd-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sxhkd";
    rev = version;
    sha256 = "1cz4vkm7fqd51ly9qjkf5q76kdqdzfhaajgvrs4anz5dyzrdpw68";
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
