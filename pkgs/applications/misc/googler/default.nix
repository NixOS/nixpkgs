{ stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  pname = "googler";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "13jj15ph0vmbyxjslzl6z4h5b7wyllvhwgsrb6zf7qlkcmkd4vwy";
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
