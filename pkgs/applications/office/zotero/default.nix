{ stdenv, fetchurl, bash, xulrunner }:

assert (stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux");

let
  version = "4.0.20";
  arch = if stdenv.system == "x86_64-linux"
           then "linux-x86_64"
           else "linux-i686";
in
stdenv.mkDerivation {
  name = "zotero-${version}";

  src = fetchurl {
    url = "https://download.zotero.org/standalone/${version}/Zotero-${version}_${arch}.tar.bz2";
    sha256 = if stdenv.system == "x86_64-linux"
               then "0d7813k3h60fpxabdwiw83g5zfy9knxc9irgxxz60z31vd14zi0x"
               else "0nj4mj22bkn2nwbkfs40kg4br6h6gcf718v9lfnvs13cyhx0wapc";
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
