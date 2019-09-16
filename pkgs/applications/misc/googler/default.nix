{stdenv, fetchFromGitHub, python}:

stdenv.mkDerivation rec {
  version = "3.9";
  pname = "googler";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "googler";
    rev = "v${version}";
    sha256 = "0zqq157i0rfrja8yqnqr9rfrp5apzc7cxb7d7ppv6abkc5bckyqc";
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
