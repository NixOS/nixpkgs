{ stdenv, fetchurl, pkgconfig, deadbeef, gtk3, libxml2 }:

stdenv.mkDerivation rec {
  name = "deadbeef-infobar-plugin-${version}";
  version = "1.4";

  src = fetchurl {
    url = "https://bitbucket.org/dsimbiriatin/deadbeef-infobar/downloads/deadbeef-infobar-${version}.tar.gz";
    sha256 = "0c9wh3wh1hdww7v96i8cy797la06mylhfi0880k8vwh88079aapf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ deadbeef gtk3 libxml2 ];

  buildFlags = [ "gtk3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/deadbeef
    cp gtk3/ddb_infobar_gtk3.so $out/lib/deadbeef

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "DeadBeeF Infobar Plugin";
    homepage = https://bitbucket.org/dsimbiriatin/deadbeef-infobar;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
