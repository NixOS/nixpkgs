{ stdenv, fetchurl, pkgconfig, libsoup, webkit, gtk, glib_networking
, gsettings_desktop_schemas, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "vimb-${version}";
  version = "2.6";

  src = fetchurl {
    url = "https://github.com/fanglingsu/vimb/archive/${version}.tar.gz";
    sha256 = "1g6zm5fk3k52jk3vbbzj7rm0kanykd4zgxrqhlvj3qzj2nsn4a21";
  };

  # Nixos default ca bundle
  patchPhase = ''
    sed -i s,/etc/ssl/certs/ca-certificates.crt,/etc/ssl/certs/ca-bundle.crt, src/setting.c
  '';

  buildInputs = [ makeWrapper gtk libsoup pkgconfig webkit gsettings_desktop_schemas ];

  makeFlags = [ "PREFIX=$(out)" ];

  preFixup = ''
    wrapProgram "$out/bin/vimb" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    description = "A Vim-like browser";
    longDescription = ''
      A fast and lightweight vim like web browser based on the webkit web
      browser engine and the GTK toolkit. Vimb is modal like the great vim
      editor and also easily configurable during runtime. Vimb is mostly
      keyboard driven and does not detract you from your daily work.
    '';
    homepage = "http://fanglingsu.github.io/vimb/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
