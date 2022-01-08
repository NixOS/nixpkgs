{ lib
, stdenv
, fetchurl
, emacs
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "tramp";
  version = "2.5.2";

  src = fetchurl {
    url = "mirror://gnu/tramp/${pname}-${version}.tar.gz";
    hash = "sha256-vSwU484g+WahCJXG8T/efT2k1w0nVbeK3dS1Ee2res4=";
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
