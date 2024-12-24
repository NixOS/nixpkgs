{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "sblim-sfcc";
  version = "2.2.9"; # this is technically 2.2.9-preview

  src = fetchFromGitHub {
    owner = "kkaempf";
    repo = "sblim-sfcc";
    rev = "514a76af2020fd6dc6fc380df76cbe27786a76a2";
    sha256 = "06c1mskl9ixbf26v88w0lvn6v2xd6n5f0jd5mckqrn9j4vmh70hs";
  };

  buildInputs = [ curl ];

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Small Footprint CIM Client Library";
    homepage = "https://sourceforge.net/projects/sblim/";
    license = licenses.cpl10;
    maintainers = with maintainers; [ deepfire ];
    platforms = platforms.unix;
  };
}
