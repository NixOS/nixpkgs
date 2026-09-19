{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "serviio";
  version = "2.5";

  src = fetchurl {
    url = "https://download.serviio.org/releases/${pname}-${version}-linux.tar.gz";
    sha256 = "sha256-FIUtjdhpWSQbOrS9JySgA6DJqNJv6FRWOQ9gsJYAzN0=";
  };

  installPhase = ''
    mkdir -p $out
    cp -R config legal lib library plugins LICENCE.txt NOTICE.txt README.txt RELEASE_NOTES.txt $out
  '';

  meta = {
    homepage = "https://serviio.org";
    description = "UPnP Media Streaming Server";
    longDescription = ''
      Serviio is a free media server. It allows you to stream your media files (music, video or images)
      to any DLNA-certified renderer device (e.g. a TV set, Bluray player, games console) on your home network.
    '';
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.thpham ];
    platforms = lib.platforms.linux;
  };
}
