{ stdenv, fetchgit, libowfat, zlib }:

stdenv.mkDerivation {
  name = "opentracker-2016-10-02";

  src = fetchgit {
    url = "git://erdgeist.org/opentracker";
    rev = "0ebc0ed6a3e3b7acc9f9e338cc23cea5f4f22f61";
    sha256 = "0qi0a8fygjwgs3yacramfn53jdabfgrlzid7q597x9lr94anfpyl";
  };

  buildInputs = [ libowfat zlib ];

  installPhase = ''
    mkdir -p $out/bin $out/share/doc
    cp opentracker $out/bin
    cp opentracker.conf.sample $out/share/doc
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://erdgeist.org/arts/software/opentracker/;
    license = licenses.beerware;
    platforms = platforms.linux;
    description = "Bittorrent tracker project which aims for minimal resource usage and is intended to run at your wlan router.";
    maintainers = with maintainers; [ makefu ];
  };
}
