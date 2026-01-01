{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "monocypher";
  version = "4.0.2";

  src = fetchurl {
    url = "https://monocypher.org/download/monocypher-${version}.tar.gz";
    hash = "sha256-ONBxeXOMDJBnfbo863p7hJa8/qdYuhpT6AP+0wrgh5w=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Boring crypto that simply works";
    homepage = "https://monocypher.org";
    license = with lib.licenses; [
      bsd2
      cc0
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sikmir ];
=======
  meta = with lib; {
    description = "Boring crypto that simply works";
    homepage = "https://monocypher.org";
    license = with licenses; [
      bsd2
      cc0
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sikmir ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
