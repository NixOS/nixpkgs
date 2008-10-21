{ stdenv, fetchurl
, SDL, SDL_mixer, gstreamer, gstreamerPluginsBase
, libogg, libxml2, libjpeg, mesa, libpng, libungif, libtool
, boost, freetype, agg, dbus, curl, pkgconfig, gettext
, glib, gtk, x11, ming, dejagnu, python
, lib}:

let version = "0.8.4"; in
stdenv.mkDerivation rec {
  name = "gnash-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnash/${version}/${name}.tar.bz2";
    sha256 = "094jky77ghdisq17z742cwn3g9ckm937p8h5jbji5rrdqbdlpzkg";
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
  buildInputs = [
    gettext x11 SDL SDL_mixer gstreamer gstreamerPluginsBase libtool
    libogg libxml2 libjpeg mesa libpng libungif boost freetype agg
    dbus curl pkgconfig glib gtk

    # For the test suite
    ming dejagnu python
  ];

  inherit SDL_mixer SDL;

  # Make sure `gtk-gnash' gets `libXext' in its `RPATH'.
  NIX_LDFLAGS="-lX11 -lXext";

  #doCheck = true;

  preInstall = ''ensureDir $out/plugins'';
  postInstall = ''make install-plugins'';

  meta = {
    homepage = http://www.gnu.org/software/gnash/;
    description = "GNU Gnash, an SWF movie player";
    license = "GPLv3+";
  };
} // {mozillaPlugin = "/plugins";}
