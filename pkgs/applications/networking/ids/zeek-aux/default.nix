{ lib
, cmake
, fetchFromGitHub
, flex
, libpcap
, openssl
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "zeek-aux";
  version = "0.49";

  src = fetchFromGitHub {
    owner = "zeek";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WoGJRo+zED+zA5aYwACvcPgDz2w+JjwYV8kZQMzV/gY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl libpcap flex ];

  meta = with lib; {
    description = "Zeek Auxiliary Programs";
    homepage = "https://github.com/zeek/zeek-aux";
    license = licenses.free; # similar to licenses.bsdOriginalUC but with 3 clauses instead of 4
    maintainers = with maintainers; [ dit7ya ];
  };
}
