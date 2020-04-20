{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, mono
, gtk-sharp-2_0
, gettext
, makeWrapper
, glib
, gtk2-x11
, gnome2
}:

stdenv.mkDerivation rec {
  pname = "bless";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "afrantzis";
    repo = pname;
    rev = "v${version}";
    sha256 = "04ra2mcx3pkhzbhcz0zwfmbpqj6cwisrypi6xbc2d6pxd4hdafn1";
  };

  buildInputs = [
    gtk-sharp-2_0
    mono
    # runtime only deps
    glib
    gtk2-x11
    gnome2.libglade
  ];

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
    gettext
    makeWrapper
  ];

  configureFlags = [
    # scrollkeeper is a gnome2 package, so it must be old and we shouldn't really support it
    # NOTE: that sadly doesn't turn off the compilation of the manual with scrollkeeper, so we have to fake the binaries below
    "--without-scrollkeeper"
  ];

  autoreconfPhase = ''
    mkdir _bin

    # this fakes the scrollkeeper commands, to keep the build happy
    for f in scrollkeeper-preinstall scrollkeeper-update; do
      echo "true" > ./_bin/$f
      chmod +x ./_bin/$f
    done

    export PATH="$PWD/_bin:$PATH"

    # and it also wants to install that file
    touch ./doc/user/bless-manual.omf

    # patch mono path
    sed "s|^mono|${mono}/bin/mono|g" -i src/bless-script.in

    ./autogen.sh
    '';

  preFixup = ''
    MPATH="${gtk-sharp-2_0}/lib/mono/gtk-sharp-2.0:${glib.out}/lib:${gtk2-x11}/lib:${gnome2.libglade}/lib:${gtk-sharp-2_0}/lib"
    wrapProgram $out/bin/bless --prefix MONO_PATH : "$MPATH" --prefix LD_LIBRARY_PATH : "$MPATH"
    '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/afrantzis/bless";
    description = "Gtk# Hex Editor";
    maintainers = [ maintainers.mkg20001 ];
    license = licenses.gpl2;
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
