{ stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  pname = "googler";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "04d7n2l159s7c9xzvyvbnbii1k3zdbajagpx09x1l692cwjbvpxw";
  };

  propagatedBuildInputs = [ python ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jarun/googler";
    description = "Google Search, Google Site Search, Google News from the terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ koral filalex77 ];
    platforms = platforms.unix;
  };
}
