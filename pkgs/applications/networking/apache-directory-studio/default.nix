{ stdenv, fetchurl, xorg, jre, makeWrapper }:

let
  rpath = stdenv.lib.makeLibraryPath (with xorg; [
    libXtst
  ]);
in
stdenv.mkDerivation rec {
  name = "apache-directory-studio-${version}";
  version = "2.0.0.v20170904-M13";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://apache/directory/studio/${version}/ApacheDirectoryStudio-${version}-linux.gtk.x86_64.tar.gz";
        sha256 = "1jfnm6m0ijk31r30hhrxxnizk742dm317iny041p29v897rma7aq";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "mirror://apache/directory/studio/${version}/ApacheDirectoryStudio-${version}-linux.gtk.x86.tar.gz";
        sha256 = "1bxmgram42qyhrqkgp5k8770f5mjjdd4c6xl4gj09smiycm1qa4n";
      }
    else throw "Unsupported system: ${stdenv.system}";

  buildInputs = [ makeWrapper ];

  installPhase = ''
    dest="$out/libexec/ApacheDirectoryStudio"
    mkdir -p "$dest"
    cp -r . "$dest"

    mkdir -p "$out/bin"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$dest/ApacheDirectoryStudio"
    makeWrapper "$dest/ApacheDirectoryStudio" \
        "$out/bin/ApacheDirectoryStudio" \
        --prefix PATH : "${jre}/bin" \
        --prefix LD_LIBRARY_PATH : "${rpath}"
  '';

  meta = with stdenv.lib; {
    description = "Eclipse-based LDAP browser and directory client";
    homepage = "https://directory.apache.org/studio/";
    license = licenses.asl20;
    # Upstream supports macOS and Windows too.
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
