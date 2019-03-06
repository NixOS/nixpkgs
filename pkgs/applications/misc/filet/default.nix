{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "filet";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "buffet";
    repo = "filet";
    rev = version;
    sha256 = "0mpq0jlm7z853ybmijm2s7vb97afhjj80kgsc65ajb5lg95k6mnm";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A fucking fucking fast file fucker (afffff)";
    homepage = https://github.com/buffet/filet;
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ buffet ];
  };
}
