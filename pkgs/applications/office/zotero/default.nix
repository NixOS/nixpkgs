{ stdenv, fetchurl, bash, xulrunner }:

assert (stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux");

let
  version = "4.0.21.1";
  arch = if stdenv.system == "x86_64-linux"
           then "linux-x86_64"
           else "linux-i686";
in
stdenv.mkDerivation {
  name = "zotero-${version}";

  src = fetchurl {
    url = "https://download.zotero.org/standalone/${version}/Zotero-${version}_${arch}.tar.bz2";
    sha256 = if stdenv.system == "x86_64-linux"
               then "1d6ih9q0daxxqqbr134la5y39648hpd53srf43lljjs8wr71wbn8"
               else "121myzwxw3frps77lpzza82glyz9qgwbl5bh3zngfx9vwx3n8q0v";
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
