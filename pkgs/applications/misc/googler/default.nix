{stdenv, fetchFromGitHub, python}:

stdenv.mkDerivation rec {
  version = "3.5";
  name = "googler-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "googler";
    rev = "v${version}";
    sha256 = "0z5cngg1kr3b484zddqlg9yn7crbmnd78pdb8vzd32mkp3fahcxa";
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
