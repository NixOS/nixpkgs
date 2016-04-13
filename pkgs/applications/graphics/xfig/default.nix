{ stdenv, fetchurl, makeWrapper, imake
, xlibsWrapper, libXpm, libXmu, libXi, libXp, Xaw3d, libpng, libjpeg}:

let version = "3.2.5b"; in
stdenv.mkDerivation {
  name = "xfig-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/xfig.${version}.full.tar.gz";
    sha256 = "1hl5x49sgc0vap411whhcq6qhvh4xbjg7jggv7ih9pplg5nwy0aw";
  };

  builder = ./builder.sh;

  buildInputs = [xlibsWrapper libXpm libXmu libXi libXp Xaw3d libpng libjpeg];

  nativeBuildInputs = [ imake makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${libXpm.dev}/include/X11";

  patches =
    let
      debPrefix = "http://patch-tracker.debian.org/patch/series/dl/xfig/1:3.2.5.b-3";
    in
    [
      (fetchurl {
        url = "${debPrefix}/35_CVE-2010-4262.patch";
        sha256 = "1pj669sz49wzjvvm96gwbnani7wqi0ijh21imqdzqw47qxdv7zp5";
      })
      (fetchurl {
        url = "${debPrefix}/13_remove_extra_libs.patch";
        sha256 = "1qb14ay0c8xrjzhi21jl7sl8mdzxardldzpnflkzml774bbpn8av";
      })
      (fetchurl {
        url = "${debPrefix}/36_libpng15.patch";
        sha256 = "0jd5bqj7sj9bbnxg2d0y6zmv4ka4qif2x4zc84ngdqga5433anvn";
      })
    ];

  meta = {
    description = "An interactive drawing tool for X11";
    homepage = http://xfig.org;
    platforms = stdenv.lib.platforms.gnu;         # arbitrary choice
  };
}
