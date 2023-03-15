{ lib, stdenv, fetchurl, makeWrapper, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "insync";
  version = "1.5.7.37371";
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "http://s.insynchq.com/builds/insync-portable_${version}_amd64.tar.bz2";
        sha256 = "1cm3q6y2crw6pcsvh21sbkmh1hin7xl4fyslc96nbyql8rxsky5n";
      }
    else
      throw "${pname}-${version} is not supported on ${stdenv.hostPlatform.system}";

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

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
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    homepage = "https://www.insynchq.com";
    description = "Google Drive sync and backup with multiple account support";
    longDescription = ''
     Insync is a commercial application that syncs your Drive files to your
     computer.  It has more advanced features than Google's official client
     such as multiple account support, Google Doc conversion, symlink support,
     and built in sharing.

     There is a 15-day free trial, and it is a paid application after that.
    '';
    # download URL removed
    broken = true;
  };
}
