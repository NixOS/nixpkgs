{stdenv, fetchFromGitHub, python}:

stdenv.mkDerivation rec {
  version = "3.6";
  name = "googler-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "googler";
    rev = "v${version}";
    sha256 = "1j1755b9mfmkqkgjrlsi4wr82352pqc9rfyalammqn6qrm3v3lb6";
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
