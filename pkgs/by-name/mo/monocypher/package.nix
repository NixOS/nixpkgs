{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "monocypher";
  version = "4.0.2";

  src = fetchurl {
    url = "https://monocypher.org/download/monocypher-${finalAttrs.version}.tar.gz";
    hash = "sha256-ONBxeXOMDJBnfbo863p7hJa8/qdYuhpT6AP+0wrgh5w=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = {
    description = "Boring crypto that simply works";
    homepage = "https://monocypher.org";
    license = with lib.licenses; [
      bsd2
      cc0
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sikmir ];
  };
})
