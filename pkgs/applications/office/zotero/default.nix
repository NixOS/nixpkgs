{ stdenv, fetchurl, bash, xulrunner }:

assert (stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux");

let
  version = "4.0.19";
  arch = if stdenv.system == "x86_64-linux"
           then "linux-x86_64"
           else "linux-i686";
in
stdenv.mkDerivation {
  name = "zotero-${version}";

  src = fetchurl {
    url = "https://download.zotero.org/standalone/${version}/Zotero-${version}_${arch}.tar.bz2";
    sha256 = if stdenv.system == "x86_64-linux"
               then "0xihvk7ms1vvzmxvpw8hs15pl1vvmf3zd72nwyaqhg469kwcz9s1"
               else "1z4q8nzl90snb03ywk0cp64nv3cgasj9fvbcw2d4bgl2zlgwzpy9";
  };

  # Strip the bundled xulrunner
  prePatch = ''rm -fr run-zotero.sh zotero xulrunner/'';

  inherit bash xulrunner;
  installPhase = ''
    ensureDir "$out/libexec/zotero"
    cp -vR * "$out/libexec/zotero/"

    ensureDir "$out/bin"
    substituteAll "${./zotero.sh}" "$out/bin/zotero"
    chmod +x "$out/bin/zotero"
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
  };
}
