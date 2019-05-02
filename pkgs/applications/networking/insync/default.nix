{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "insync-${version}";
  version = "1.5.5.37367";
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "http://s.insynchq.com/builds/insync-portable_${version}_amd64.tar.bz2";
        sha256 = "1yz8l8xjr0pm30hvv4w59wzs569xzkpn8lv12pyl82r1l16h5zp3";
      }
    else
      throw "${name} is not supported on ${stdenv.hostPlatform.system}";

  buildInputs = [ makeWrapper ];

  postPatch = ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" client/insync-portable
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a client $out/client
    makeWrapper $out/client/insync-portable $out/bin/insync --set LC_TIME C
  '';

  meta = {
    platforms = ["x86_64-linux"];
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.benley ];
    homepage = https://www.insynchq.com;
    description = "Google Drive sync and backup with multiple account support";
    longDescription = ''
     Insync is a commercial application that syncs your Drive files to your
     computer.  It has more advanced features than Google's official client
     such as multiple account support, Google Doc conversion, symlink support,
     and built in sharing.

     There is a 15-day free trial, and it is a paid application after that.
    '';
  };
}
