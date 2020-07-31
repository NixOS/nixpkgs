{ stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  pname = "googler";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c480wzc7q4pks1f6mnayr580c73jhzshliz4hgznzc7zwcdf41w";
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
