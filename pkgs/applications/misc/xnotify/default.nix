{ lib, stdenv, fetchFromGitHub, libX11, libXinerama, libXft, imlib2 }:

stdenv.mkDerivation {
  pname = "xnotify";
  version = "unstable-2021-12-22";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xnotify";
    rev = "cacfb959effd61f932faf87c4e5bf37c9d2ef2ea";
    sha256 = "1hvgfrcpzp7q6jn808f7jj824360mlfhym60w02ylh99p582hc3c";
  };

  buildInputs = [
    libX11 libXinerama libXft imlib2
  ];
  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "xnotify - popup a notification on the screen";
    longDescription = ''
      xnotify is a notification launcher for X, it receives a notification
      specification from standard input and shows a notification on the screen.
      The notification disappears automatically after a given number of seconds 
      or after a mouse click is operated on it.
    '';
    homepage = "https://github.com/phillbush/xnotify";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ CarlosLoboxyz ];
  };
}
