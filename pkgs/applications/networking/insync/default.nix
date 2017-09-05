{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "insync-${version}";
  version = "1.3.17.36167";
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://s.insynchq.com/builds/insync-portable_${version}_amd64.tar.bz2";
        sha256 = "0mvg22psiy4x9g7k1fm9pigz2a70jmin7zg2nfzapfnqjlnrbw3n";
      }
    else
      throw "${name} is not supported on ${stdenv.system}";

  buildInputs = [ makeWrapper ];

  postPatch = ''
    patchelf --interpreter "$(cat $NIX_BINUTILS/nix-support/dynamic-linker)" client/insync-portable
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
