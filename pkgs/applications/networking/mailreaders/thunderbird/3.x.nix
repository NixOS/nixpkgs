{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, zlib, cairo, dbus, dbus_glib, bzip2
, freetype, fontconfig, xulrunner
, autoconf , libpng , alsaLib, sqlite, patchelf

, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Mail", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

stdenv.mkDerivation {
  name = "thunderbird-3.0beta2";

  src = fetchurl {
    url = "ftp://ftp.mozilla.org/pub/thunderbird/releases/3.0b2/source/thunderbird-3.0b2-source.tar.bz2";
    sha256 = "17mlp0x6sf1v9w8vraln7mr566gvk84rxvxiwzhbdj2p0475zjqr";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libjpeg zlib cairo bzip2
    python dbus dbus_glib pango freetype fontconfig autoconf
    libpng alsaLib sqlite patchelf
  ];

  propagatedBuildInputs = [xulrunner];

  preUnpack = "mkdir thunderbird; cd thunderbird;";
  setSourceRoot = "export sourceRoot=.;";
  preConfigure = ''
    for i in $(find . -name configure.in); do echo $i; (cd $(dirname $i); autoconf || true; ); done;
    XUL_SDK=$(echo ${xulrunner}/lib/xulrunner-devel-*/)
    export NIX_CFLAGS_COMPILE="''${NIX_CFLAGS_COMPILE} -I$XUL_SDK/include";
    export NIX_CFLAGS_COMPILE="''${NIX_CFLAGS_COMPILE} -I$(echo ${xulrunner}/include/xulrunner-*/stable)";
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE";
    export NIX_LDFLAGS="''${NIX_LDFLAGS} -L$XUL_SDK/lib -L$XUL_SDK/sdk/lib";
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${xulrunner}/lib/xulrunner-${xulrunner.version}";
    export NIX_LDFLAGS="$NIX_LDFLAGS -lxpcomglue -lxpcomglue_s -lxul -lnss -lmozjs -lsqlite3";
    echo NIX_CFLAGS_COMPILE: $NIX_CFLAGS_COMPILE
    echo NIX_LDFLAGS: $NIX_LDFLAGS
    for i in $(find $(pwd) -wholename '*/public/*.idl' -exec dirname '{}' ';' | sort | uniq); do
      export XPIDL_FLAGS="$XPIDL_FLAGS -I$i";
    done;
    echo $XPIDL_FLAGS

    sed -e "s@\$(XPIDL_FLAGS)@\$(XPIDL_FLAGS) $XPIDL_FLAGS@" -i config/rules.mk
  '';
  postConfigure = ''
    (cd mozilla/nsprpub; ./configure --prefix=$out/XUL_SDK; )
  '';
  preBuild = ''
    for i in $(find . -name autoconf.mk); do echo $i; sed -e 's@-Wl,-rpath-link,$(PREFIX)/lib@@' -i $i; done
    make -C mozilla/config nsinstall
    mkdir -p $out/libexec/mozilla/nsinstall
    mv mozilla/config/nsinstall $out/libexec/mozilla/nsinstall/nsinstall
    cat > mozilla/config/nsinstall <<EOF
    #! /bin/sh
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${sqlite}/lib:${xulrunner}/lib/xulrunner-${xulrunner.version}"
    $out/libexec/mozilla/nsinstall/nsinstall "\$@"
    EOF
    chmod a+x mozilla/config/nsinstall
  '';

  configureFlags = [
    "--enable-application=mail"
    "--enable-optimize"
    "--disable-debug"
    "--with-system-jpeg"
    "--with-system-zlib"
    "--with-system-bz2"
    #"--with-system-png" # <-- "--with-system-png won't work because the system's libpng doesn't have APNG support"
    "--enable-system-cairo"
    #"--enable-system-sqlite" # <-- this seems to be discouraged
    "--disable-crashreporter"
    "--with-libxul-sdk=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"
    "--enable-extensions=default"
  ]
  ++ (if enableOfficialBranding then ["--enable-official-branding"] else []);

  postInstall = ''
    # Strip some more stuff.
    strip -S $out/lib/*/* || true

    libDir=$(cd $out/lib && ls -d thunderbird-[0-9]*)
    test -n "$libDir"
    
    ln -s ${xulrunner}/lib/xulrunner-${xulrunner.version} $out/lib/$libDir/xulrunner

    # Register extensions etc. !!! is this needed anymore?
    echo "running thunderbird -register..."
    $out/bin/thunderbird -register
  ''; # */

  meta = {
    description = "Mozilla Thunderbird, a full-featured email client";
    homepage = http://www.mozilla.com/en-US/thunderbird/;
  };

  passthru = {
    inherit gtk;
  };
}
