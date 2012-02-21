{ stdenv, fetchurl, makeWrapper, imake
, x11, libXpm, libXmu, libXi, libXp, Xaw3d, libpng, libjpeg}:

let version = "3.2.5b"; in
stdenv.mkDerivation {
  name = "xfig-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/xfig.${version}.full.tar.gz";
    sha256 = "1hl5x49sgc0vap411whhcq6qhvh4xbjg7jggv7ih9pplg5nwy0aw";
  };

  builder = ./builder.sh;

  buildInputs = [x11 libXpm libXmu libXi libXp Xaw3d libpng libjpeg];

  buildNativeInputs = [ imake makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${libXpm}/include/X11";

  patches =
    let
      debPrefix = "http://patch-tracker.debian.org/patch/series/dl/xfig/1:3.2.5.b-2";
    in
    [
      (fetchurl {
        url = "${debPrefix}/35_CVE-2010-4262.dpatch";
        sha256 = "18741b3dbipgr55fyp5x0296za3336ylln639jw8yjcyd1call22";
      })
      (fetchurl {
        url = "${debPrefix}/13_remove_extra_libs.dpatch";
        sha256 = "0v3k30ib7xq5wfhd3yacnal4gbih7nqw0z0aycvc0hafffl97i46";
      })
      (fetchurl {
        url = "${debPrefix}/36_libpng15.dpatch";
        sha256 = "0ssmvlcpjn3iqj3l38db8j8qpqbzixlwpczq01m49r5w9l3viy8k";
      })
    ];

  meta = {
    description = "An interactive drawing tool for X11";
    homepage = http://xfig.org;
    platforms = stdenv.lib.platforms.gnu;         # arbitrary choice
  };
}
