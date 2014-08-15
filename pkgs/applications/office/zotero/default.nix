{ stdenv, fetchurl, bash, xulrunner }:

assert (stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux");

let
  version = "4.0.21.2";
  arch = if stdenv.system == "x86_64-linux"
           then "linux-x86_64"
           else "linux-i686";
in
stdenv.mkDerivation {
  name = "zotero-${version}";

  src = fetchurl {
    url = "https://download.zotero.org/standalone/${version}/Zotero-${version}_${arch}.tar.bz2";
    sha256 = if stdenv.system == "x86_64-linux"
               then "1df101j2qwdp001m8x3ihbzz2j23x43804k8ww749y09d1ydb4dx"
               else "1bcrpl6gdxlygd5ppyrhw42q24kjcakma3qv6mpzgp91phkf6g30";
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
