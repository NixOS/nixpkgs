{ stdenv, fetchurl, makeWrapper, pkgconfig, gtk2, gtk2-x11
, gtkspell2, aspell
, gst_all_1, startupnotification, gettext
, perlPackages, libxml2, nss, nspr, farstream
, libXScrnSaver, ncurses, avahi, dbus, dbus-glib, intltool, libidn
, lib, python, libICE, libXext, libSM
, cyrus_sasl ? null
, openssl ? null
, gnutls ? null
, libgcrypt ? null
, plugins, symlinkJoin
}:

# FIXME: clean the mess around choosing the SSL library (nss by default)

let unwrapped = stdenv.mkDerivation rec {
  pname = "pidgin";
  majorVersion = "2";
  version = "${majorVersion}.13.0";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/${pname}-${version}.tar.bz2";
    sha256 = "13vdqj70315p9rzgnbxjp9c51mdzf1l4jg1kvnylc4bidw61air7";
  };

  inherit nss ncurses;

  nativeBuildInputs = [ makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  buildInputs = let
    python-with-dbus = python.withPackages (pp: with pp; [ dbus-python ]);
  in [
    aspell startupnotification
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    libxml2 nss nspr
    libXScrnSaver ncurses python-with-dbus
    avahi dbus dbus-glib intltool libidn
    libICE libXext libSM cyrus_sasl
  ]
  ++ (lib.optional (openssl != null) openssl)
  ++ (lib.optional (gnutls != null) gnutls)
  ++ (lib.optional (libgcrypt != null) libgcrypt)
  ++ (lib.optionals (stdenv.isLinux) [gtk2 gtkspell2 farstream])
  ++ (lib.optional (stdenv.isDarwin) gtk2-x11);


  propagatedBuildInputs = [ pkgconfig gettext ]
    ++ (with perlPackages; [ perl XMLParser ])
    ++ (lib.optional (stdenv.isLinux) gtk2)
    ++ (lib.optional (stdenv.isDarwin) gtk2-x11);

  patches = [ ./pidgin-makefile.patch ./add-search-path.patch ];

  configureFlags = [
    "--with-nspr-includes=${nspr.dev}/include/nspr"
    "--with-nspr-libs=${nspr.out}/lib"
    "--with-nss-includes=${nss.dev}/include/nss"
    "--with-nss-libs=${nss.out}/lib"
    "--with-ncurses-headers=${ncurses.dev}/include"
    "--disable-meanwhile"
    "--disable-nm"
    "--disable-tcl"
  ]
  ++ (lib.optionals (cyrus_sasl != null) [ "--enable-cyrus-sasl=yes" ])
  ++ (lib.optionals (gnutls != null) ["--enable-gnutls=yes" "--enable-nss=no"])
  ++ (lib.optionals (stdenv.isDarwin) ["--disable-gtkspell" "--disable-vv"]);

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/pidgin \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  # In particular, this detects missing python imports in some of the tools.
  postInstallCheck = ''
    for f in "''${!outputBin}"/bin/{purple-remote,pidgin}; do
      echo "Testing: $f --help"
      "$f" --help
    done
  '';

  meta = with stdenv.lib; {
    description = "Multi-protocol instant messaging client";
    homepage = "http://pidgin.im";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
};

in if plugins == [] then unwrapped
    else import ./wrapper.nix {
      inherit makeWrapper symlinkJoin plugins;
      pidgin = unwrapped;
    }
