{ stdenv, fetchurl, oraclejre8, ... }:

stdenv.mkDerivation rec {
  name = "bwSyncAndShare-${version}";
  version = "11.6.703";

  src = fetchurl {
    # No version-numbered tarball available, only a "Latest" version.
    # This will break whenever a new version is published.
    url = https://download.bwsyncandshare.kit.edu/clients/bwSyncAndShare_Latest_Linux.tar.gz;
    sha256 = "1yw81l9pv5qkl5l12i7lgma4bvn5jfnj1w1s68pfwzc145zzh8cc";
  };

  # Upstream package includes a bundled Oracle jre8. We replace this with a dependency
  # to support multiple platforms. Current version refuses to run with openjdk.
  buildInputs = [ oraclejre8 ];

  patchPhase = ''
    substituteInPlace install-files/bwSyncAndShare.desktop --replace "/usr/share/" "$out/share/"
    substituteInPlace bwSyncAndShare-Client.sh \
       --replace '$CLIENT_INSTALL/jre/bin/java' "${oraclejre8}/bin/java" \
       --replace "CLIENT_INSTALL=." "CLIENT_INSTALL=$out/share/bwSyncAndShare"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D -m 644 -t $out/share/bwSyncAndShare/ bwSyncAndShare.jar
    install -D -m 755 -t $out/share/bwSyncAndShare/ bwSyncAndShare-Client.sh
    ln -s $out/share/bwSyncAndShare/bwSyncAndShare-Client.sh $out/bin/bwSyncAndShare
    install -D -m 644 -t $out/share/icons/hicolor/128x128/apps/ install-files/bwSyncAndShare.png
    install -D -m 644 -t $out/share/applications/ install-files/bwSyncAndShare.desktop
    install -D -m 644 -t $out/ LICENSE README VERSION
  '';

  meta = with stdenv.lib; {
    description = "Client for a file sync/share service run by some German state universities.";
    homepage = https://bwsyncandshare.kit.edu;
    license = licenses.unfree;
    platforms = oraclejre8.meta.platforms;
    maintainers = with maintainers; [ xeji ];
  };

}
