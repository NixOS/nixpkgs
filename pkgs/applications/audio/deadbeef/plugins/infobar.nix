{ lib, stdenv, fetchurl, pkg-config, deadbeef, gtk3, libxml2 }:

stdenv.mkDerivation rec {
  pname = "deadbeef-infobar-plugin";
  version = "1.4";

  src = fetchurl {
    url = "https://bitbucket.org/dsimbiriatin/deadbeef-infobar/downloads/deadbeef-infobar-${version}.tar.gz";
    sha256 = "0c9wh3wh1hdww7v96i8cy797la06mylhfi0880k8vwh88079aapf";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ deadbeef gtk3 libxml2 ];

  buildFlags = [ "gtk3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/deadbeef
    cp gtk3/ddb_infobar_gtk3.so $out/lib/deadbeef

    runHook postInstall
  '';

  meta = with lib; {
    broken = true; # crashes DeaDBeeF and is abandoned (https://bitbucket.org/dsimbiriatin/deadbeef-infobar/issues/38/infobar-causes-deadbeef-180-to-crash)
    description = "DeaDBeeF Infobar Plugin";
    homepage = "https://bitbucket.org/dsimbiriatin/deadbeef-infobar";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
