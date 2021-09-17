{ lib
, stdenv
, fetchurl
, emacs
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "tramp";
  version = "2.5.1";

  src = fetchurl {
    url = "mirror://gnu/tramp/${pname}-${version}.tar.gz";
    hash = "sha256-+jjWBcj2dP9Xyj4dzpAX86KnajVa9eFDcjD9xTw6vks=";
  };

  buildInputs = [
    emacs
    texinfo
  ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/tramp";
    description = "Transparently access remote files from Emacs (latest version)";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (emacs.meta) platforms;
  };
}
