{ stdenv, fetchurl, bash, callPackage, libIDL, pysqlite }:

assert (stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux");


let
  /* Zotero always has a hard upper bound on its firefox/xulrunner dependency.
   * Use private versions of firefox and xulrunner to prevent breakage when the
   * system packages are updated. Please update these dependencies whenever
   * zotero is updated; it should be as simple as copying the system firefox
   * and xulrunner Nix expressions into place.
   */
  firefox = callPackage ./firefox.nix { inherit libIDL pysqlite; };
  xulrunner = callPackage ./xulrunner.nix { inherit libIDL pysqlite firefox; };

  # Please update the firefox and xulrunner dependencies when zotero is updated!
  version = "4.0.23";
  arch = if stdenv.system == "x86_64-linux"
           then "linux-x86_64"
           else "linux-i686";
in
stdenv.mkDerivation {
  name = "zotero-${version}";

  src = fetchurl {
    url = "https://download.zotero.org/standalone/${version}/Zotero-${version}_${arch}.tar.bz2";
    sha256 = if stdenv.system == "x86_64-linux"
               then "1fz5xn69vapfw8d20207zr9p5r1h9x5kahh334pl2dn1h8il0sm8"
               else "1kmsvvg2lh881rzy3rxbigzivixjamyrwf5x7vmn1kzhvsvifrng";
  };

  # Strip the bundled xulrunner
  prePatch = ''rm -fr run-zotero.sh zotero xulrunner/'';

  inherit bash xulrunner;
  installPhase = ''
    mkdir -p "$out/libexec/zotero"
    cp -vR * "$out/libexec/zotero/"

    mkdir -p "$out/bin"
    substituteAll "${./zotero.sh}" "$out/bin/zotero"
    chmod +x "$out/bin/zotero"
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/zotero --version";

  meta = with stdenv.lib; {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
  };
}
