{ lib
, stdenv
, fetchurl
, fetchpatch
, makeWrapper
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "bashdb";
  version = "5.0-1.1.2";

  src = fetchurl {
    url =  "mirror://sourceforge/bashdb/${pname}-${version}.tar.bz2";
    sha256 = "sha256-MBdtKtKMWwCy4tIcXqGu+PuvQKj52fcjxnxgUx87czA=";
  };

  patches = [
    # Enable building with bash 5.1/5.2
    # Remove with any upstream 5.1-x.y.z release
    (fetchpatch {
      url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/569fbb806d9ee813afa8b27d2098a44f93433922/devel/bashdb/files/patch-configure";
      sha256 = "19zfzcnxavndyn6kfxp775kjcd0gigsm4y3bnh6fz5ilhnnbbbgr";
    })
  ];
  patchFlags = [ "-p0" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/bashdb --prefix PYTHONPATH ":" "$(toPythonPath ${python3Packages.pygments})"
  '';

  meta = {
    description = "Bash script debugger";
    mainProgram = "bashdb";
    homepage = "https://bashdb.sourceforge.net/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
