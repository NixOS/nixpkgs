{ stdenv, fetchurl
, SDL, SDL_mixer, GStreamer
, libogg, libxml2, libjpeg, mesa, libpng, libtool
, boost, freetype, agg, dbus, curl, pkgconfig
, glib, gtk, x11
, lib}:

let version = "0.8.3"; in
stdenv.mkDerivation rec {
  name = "gnash-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnash/${version}/${name}.tar.bz2";
    sha256 = "16n32774sd5q4nkd95v2m8r2yfa9fk30jnq1iicarq3j8i2xh7xg";
  };

  builder = ./builder.sh;

  patchPhase = ''
    # Add all libs to `macros/libslist', a list of library search paths.
    for lib in ${lib.concatStringsSep " "
                                      (map (lib: "\"${lib}\"/lib")
                                           (buildInputs ++ [stdenv.glibc]))}
    do
      echo -n "$lib " >> macros/libslist
    done

    # Make sure to honor $TMPDIR, for chroot builds.
    for file in configure gui/Makefile.in Makefile.in
    do
      sed -i "$file" -es'|/tmp/|$TMPDIR/|g'
    done
  '';


  # XXX: KDE is supported as well so we could make it available optionally.
  buildInputs = [x11 SDL SDL_mixer GStreamer libtool
                 libogg libxml2 libjpeg mesa libpng boost freetype agg
		 dbus curl pkgconfig glib gtk];
  inherit SDL_mixer SDL;

  # Make sure `gtk-gnash' gets `libXext' in its `RPATH'.
  NIX_LDFLAGS="-lX11 -lXext";

  preInstall = ''ensureDir $out/plugins'';
  postInstall = ''make install-plugins'';

  meta = {
    homepage = http://www.gnu.org/software/gnash/;
    description = ''Gnash is the GNU Flash movie player.'';
    license = "GPLv3+";
  };
} // {mozillaPlugin = "/plugins";}
