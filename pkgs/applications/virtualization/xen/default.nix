{ stdenv, fetchurl, which, zlib, pkgconfig, SDL, openssl, python
, libuuid, gettext, ncurses, dev86, iasl, pciutils, bzip2, xz }:

let version = "4.0.1"; in 

stdenv.mkDerivation {
  name = "xen-${version}";

  src = fetchurl {
    url = "http://bits.xensource.com/oss-xen/release/${version}/xen-${version}.tar.gz";
    sha256 = "0ww8j5fa2jxg0zyx7d7z9jyv2j47m8w420sy16w3rf8d80lisvbf";
  };

  patches =
    [ # Xen looks for headers in /usr/include and for libraries using
      # ldconfig.  Don't do that.
      ./has-header.patch
    ];

  buildInputs =
    [ which zlib pkgconfig SDL openssl python libuuid gettext ncurses
      dev86 iasl pciutils bzip2 xz
    ];

  makeFlags = "PREFIX=$(out)";

  buildFlags = "xen tools";

  installPhase =
    ''
      cp -prvd dist/install/nix/store/* $out
      cp -prvd dist/install/boot $out/boot
    ''; # */

  # Set the Python search path in all Python scripts.
  postFixup =
    ''
      for fn in $(grep -l '#!.*python' $out/bin/* $out/sbin/*); do
          sed -i "$fn" -e "1 a import sys\nsys.path = ['$out/lib/python2.6/site-packages'] + sys.path"
      done
    ''; # */

  meta = {
    homepage = http://www.xen.org/;
    description = "Xen hypervisor and management tools for Dom0";
  };
}
