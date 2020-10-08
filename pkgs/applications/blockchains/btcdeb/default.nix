{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, openssl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "btcdeb-unstable";
  version = "200806";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "btcdeb";
    rev = "f6708c397c64894c9f9e31bea2d22285d9462de7";
    sha256 = "0qkmf89z2n7s95vhw3n9vh9dbi14zy4vqw3ffdh1w911jwm5ry3z";
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
