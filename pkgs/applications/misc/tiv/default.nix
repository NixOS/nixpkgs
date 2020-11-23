{ stdenv, fetchFromGitHub, imagemagick }:

stdenv.mkDerivation rec {
  pname = "tiv";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "stefanhaustein";
    repo = "TerminalImageViewer";
    rev = "v${version}";
    sha256 = "17zqbwj2imk6ygyc142mw6v4fh7h4rd5vzn5wxr9gs0g8qdc6ixn";
  };

  buildInputs = [ imagemagick ];

  makeFlags = [ "prefix=$(out)" ];

  preConfigure = "cd src/main/cpp";

  meta = with stdenv.lib; {
    homepage = "https://github.com/stefanhaustein/TerminalImageViewer";
    description = "Small C++ program to display images in a (modern) terminal using RGB ANSI codes and unicode block graphics characters";
    license = licenses.asl20;
    maintainers = with maintainers; [ magnetophon ];
    platforms = [ "x86_64-linux" ];
  };
}
