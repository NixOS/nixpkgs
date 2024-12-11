{
  stdenv,
  callPackage,
  fetchurl,
  makeWrapper,
  aspell,
  avahi,
  cacert,
  dbus,
  dbus-glib,
  farstream,
  gettext,
  gst_all_1,
  gtk2,
  gtk2-x11,
  gtkspell2,
  intltool,
  lib,
  libICE,
  libSM,
  libXScrnSaver,
  libXext,
  libgcrypt,
  libgnt,
  libidn,
  libstartup_notification,
  libxml2,
  ncurses,
  nspr,
  nss,
  perlPackages,
  pkg-config,
  python3,
  pidgin,
  plugins ? [ ],
  withOpenssl ? false,
  openssl,
  withGnutls ? false,
  gnutls,
  withCyrus_sasl ? true,
  cyrus_sasl,
  pidginPackages,
}:

# FIXME: clean the mess around choosing the SSL library (nss by default)

let
  unwrapped = stdenv.mkDerivation rec {
    pname = "pidgin";
    version = "2.14.13";

    src = fetchurl {
      url = "mirror://sourceforge/pidgin/pidgin-${version}.tar.bz2";
      sha256 = "sha256-EgBJ3I4X4JoqfSVq/yGR/4SRq7hAyMfrMZoWHi3xa6g=";
    };

    nativeBuildInputs = [
      makeWrapper
      intltool
    ];

    env.NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

    buildInputs =
      let
        python-with-dbus = python3.withPackages (pp: with pp; [ dbus-python ]);
      in
      [
        aspell
        avahi
        cyrus_sasl
        dbus
        dbus-glib
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gstreamer
        libICE
        libSM
        libXScrnSaver
        libXext
        libgnt
        libidn
        libstartup_notification
        libxml2
        ncurses # optional: build finch - the console UI
        nspr
        nss
        python-with-dbus
      ]
      ++ lib.optional withOpenssl openssl
      ++ lib.optionals withGnutls [
        gnutls
        libgcrypt
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        gtk2
        gtkspell2
        farstream
      ]
      ++ lib.optional stdenv.hostPlatform.isDarwin gtk2-x11;

    propagatedBuildInputs =
      [
        pkg-config
        gettext
      ]
      ++ (with perlPackages; [
        perl
        XMLParser
      ])
      ++ lib.optional stdenv.hostPlatform.isLinux gtk2
      ++ lib.optional stdenv.hostPlatform.isDarwin gtk2-x11;

    patches = [
      ./add-search-path.patch
      ./pidgin-makefile.patch
    ];

    configureFlags =
      [
        "--with-nspr-includes=${nspr.dev}/include/nspr"
        "--with-nspr-libs=${nspr.out}/lib"
        "--with-nss-includes=${nss.dev}/include/nss"
        "--with-nss-libs=${nss.out}/lib"
        "--with-ncurses-headers=${ncurses.dev}/include"
        "--with-system-ssl-certs=${cacert}/etc/ssl/certs"
        "--disable-meanwhile"
        "--disable-nm"
        "--disable-tcl"
        "--disable-gevolution"
      ]
      ++ lib.optionals withCyrus_sasl [ "--enable-cyrus-sasl=yes" ]
      ++ lib.optionals withGnutls [
        "--enable-gnutls=yes"
        "--enable-nss=no"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "--disable-gtkspell"
        "--disable-vv"
      ]
      ++ lib.optionals stdenv.cc.isClang [ "CFLAGS=-Wno-error=int-conversion" ];

    enableParallelBuilding = true;

    postInstall = ''
      wrapProgram $out/bin/pidgin \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    '';

    doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    # In particular, this detects missing python imports in some of the tools.
    postFixup =
      let
        # TODO: python is a script, so it doesn't work as interpreter on darwin
        binsToTest = lib.optionalString stdenv.hostPlatform.isLinux "purple-remote," + "pidgin,finch";
      in
      lib.optionalString doInstallCheck ''
        for f in "''${!outputBin}"/bin/{${binsToTest}}; do
          echo "Testing: $f --help"
          "$f" --help
        done
      '';

    passthru = {
      makePluginPath = lib.makeSearchPathOutput "lib" "lib/purple-${lib.versions.major version}";
      withPlugins =
        pluginfn:
        callPackage ./wrapper.nix {
          plugins = pluginfn pidginPackages;
          pidgin = unwrapped;
        };
    };

    meta = {
      description = "Multi-protocol instant messaging client";
      mainProgram = "pidgin";
      homepage = "https://pidgin.im/";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.unix;
      maintainers = [ lib.maintainers.lucasew ];
    };
  };

in
if plugins == [ ] then unwrapped else unwrapped.withPlugins (_: plugins)
