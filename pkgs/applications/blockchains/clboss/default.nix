{ lib
, stdenv
, fetchurl
, pkg-config
, curlWithGnuTls
, libev
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "clboss";
  version = "0.12";

  src = fetchurl {
    url = "https://github.com/ZmnSCPxj/clboss/releases/download/${version}/clboss-${version}.tar.gz";
    hash = "sha256-UZcSfbpp3vPsD3CDukp+r5Z60h0UEWTduqF4DhJ+H2U=";
  };

  nativeBuildInputs = [ pkg-config libev curlWithGnuTls sqlite ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Automated C-Lightning Node Manager";
    homepage = "https://github.com/ZmnSCPxj/clboss";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
