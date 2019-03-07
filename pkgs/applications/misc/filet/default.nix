{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "filet";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "buffet";
    repo = "filet";
    rev = version;
    sha256 = "0fk616rsninl97x4g1f4blidw6drh5dvjy6s41yf6zgragrr2xh5";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A fucking fucking fast file fucker (afffff)";
    homepage = https://github.com/buffet/filet;
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
