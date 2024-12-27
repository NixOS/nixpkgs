{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "serviio";
  version = "2.4";

  src = fetchurl {
    url = "http://download.serviio.org/releases/${pname}-${version}-linux.tar.gz";
    sha256 = "sha256-ssi2fKbAMizr5eLAMng+G25ui3v98zCNWzMg7uLgGas=";
  };

  installPhase = ''
    mkdir -p $out
    cp -R config legal lib library plugins LICENCE.txt NOTICE.txt README.txt RELEASE_NOTES.txt $out
  '';

  meta = with lib; {
    homepage = "https://serviio.org";
    description = "UPnP Media Streaming Server";
    longDescription = ''
      Serviio is a free media server. It allows you to stream your media files (music, video or images)
      to any DLNA-certified renderer device (e.g. a TV set, Bluray player, games console) on your home network.
    '';
    license = licenses.unfree;
    maintainers = [ maintainers.thpham ];
    platforms = platforms.linux;
  };
}
