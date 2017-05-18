{ stdenv, fetchurl, makeWrapper, bundlerEnv, ruby , alsaUtils, gtk, libnotify
, libXdmcp, pcre, pkgconfig, pthread_stubs, which, zlib }:

stdenv.mkDerivation rec {
  name = "mikutter-${version}";
  version = "3.5.7";

  src = fetchurl {
    url = "https://mikutter.hachune.net/bin/mikutter.${version}.tar.gz";
    sha256 = "1vh5ap92q869j69hmmbznailaflmdp0km4sqdv06cpq7v8pwm28w";
  };

  env = bundlerEnv {
    name = "mikutter-${version}-gems";
    gemdir = ./.;

    gemConfig = {
      atk = attrs: { buildInputs = [ gtk pcre pkgconfig ]; };
      cairo = attrs: {
        buildInputs = [ gtk libXdmcp pcre pkgconfig pthread_stubs ];
      };
      gio2 = attrs: { buildInputs = [ gtk pcre pkgconfig ]; };
      glib2 = attrs: { buildInputs = [ gtk pcre pkgconfig ]; };
      gtk2 = attrs: {
        buildInputs = [ gtk pcre libXdmcp pkgconfig pthread_stubs ];
        # CFLAGS must be set for this gem to detect gdkkeysyms.h correctly
        CFLAGS = "-I${gtk.dev}/include/gtk-2.0 -I/non-existent-path";
      };
      gobject-introspection = attrs: { buildInputs = [ gtk pcre pkgconfig ]; };
      pango = attrs: {
        buildInputs = [ gtk libXdmcp pcre pkgconfig pthread_stubs ];
      };
      nokogiri = attrs: { buildInputs = [ zlib ]; };
    };

    inherit ruby;
  };

  buildInputs = [ makeWrapper alsaUtils gtk libnotify ruby which ];

  postUnpack = ''
    rm -rf $sourceRoot/vendor
  '';

  installPhase = ''
    install -v -D -m644 README $out/share/doc/mikutter/README
    install -v -D -m644 LICENSE $out/share/doc/mikutter/LICENSE
    rm -v README LICENSE

    cp -rv . $out
    makeWrapper $out/mikutter.rb $out/bin/mikutter \
      --prefix PATH : "${ruby}/bin:${alsaUtils}/bin:${libnotify}/bin" \
      --prefix GEM_HOME : "${env}/${env.ruby.gemPath}" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --set DISABLE_BUNDLER_SETUP 1

    mkdir -p $out/share/mikutter $out/share/applications
    ln -sv $out/core/skin $out/share/mikutter/skin
    substituteAll ${./mikutter.desktop} $out/share/applications/mikutter.desktop
  '';

  meta = with stdenv.lib; {
    description = "An extensible Twitter client";
    homepage = "https://mikutter.hachune.net";
    platforms = ruby.meta.platforms;
    license = licenses.mit;
  };
}
