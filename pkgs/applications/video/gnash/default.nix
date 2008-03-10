{ stdenv, fetchurl
, SDL, SDL_mixer, GStreamer
, libogg, libxml2, libjpeg, mesa, libpng
, boost, freetype, agg, dbus, curl, pkgconfig
, glib, gtk, x11
, lib}:

stdenv.mkDerivation rec {
  name = "gnash-0.8.2";

  src = fetchurl {
    url = "mirror://gnu/gnash/0.8.2/${name}.tar.bz2";
    sha256 = "1akbs0wkgiawrjwwgp5w0cqn0qn3fcnfv40scjlrvdqrcqgfg0ac";
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
  '';

  # XXX: KDE is supported as well so we could make it available optionally.
  buildInputs = [x11 SDL SDL_mixer GStreamer
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
