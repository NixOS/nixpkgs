{stdenv, fetchFromGitHub, python}:

stdenv.mkDerivation rec {
  version = "3.7";
  name = "googler-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "googler";
    rev = "v${version}";
    sha256 = "0dxg849ckyy181zlrb57hd959cgvx105c35ksmvi4wl285sh5kpj";
  };

  propagatedBuildInputs = [ python ];

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/jarun/googler;
    description = "Google Search, Google Site Search, Google News from the terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.unix;
  };
}
