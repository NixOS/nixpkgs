{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, openssl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "btcdeb";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "kallewoof";
    repo = pname;
    rev = "fb2dace4cd115dc9529a81515cee855b8ce94784";
    sha256 = "0l0niamcjxmgyvc6w0wiygfgwsjam3ypv8mvjglgsj50gyv1vnb3";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl ];

  meta = {
    description = "Bitcoin Script Debugger";
    homepage = "https://github.com/kallewoof/btcdeb";
    license = licenses.mit;
    maintainers = with maintainers; [ akru ];
    platforms = platforms.unix;
  };
}
