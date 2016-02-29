{ stdenv, fetchFromGitHub, go, gmp, leveldb }:

stdenv.mkDerivation rec {
  name = "geth-${version}";
  version = "1.3.3";
  buildInputs = [go gmp];

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "8938768f75c6a3c5a0bfb8ae0fed43b7d9fb7e7a";
    sha256 = "07dx19dg5w3qg11z860v74qkbmm9i1zb42az7xhkh763gq62lj0a";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r build/bin "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Ethereum blockchain client";
    homepage = "https://ethereum.org/";
    maintainers = with maintainers; [ dvc ];
    license = licenses.gpl3;
  };
}
