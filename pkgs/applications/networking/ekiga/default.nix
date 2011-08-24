x@{builderDefsPackage
  , cyrus_sasl, gettext, openldap, ptlib, opal, GConf, libXv, rarian, intltool
  , perl, perlXMLParser, evolution_data_server, gnome_doc_utils, avahi
  , libsigcxx, gtk, dbus_glib, libnotify, libXext, xextproto, automake
  , autoconf, pkgconfig, libxml2, videoproto, unixODBC, db4, nspr, nss, zlib
  , libXrandr, randrproto, which, libxslt, libtasn1, gmp, nettle
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="ekiga";
    baseVersion="3.2";
    patchlevel="7";
    version="${baseVersion}.${patchlevel}";
    name="${baseName}-${version}";
    url="mirror://gnome/sources/${baseName}/${baseVersion}/${name}.tar.bz2";
    hash="13zxwfqhp7pisadx0hq50qwnj6d8r4dldvbs1ngydbwfnq4i6npj";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doConfigure" "doMakeInstall"];
  configureFlags = [
    "--with-ldap-dir=${openldap}"
    "--with-libsasl2-dir=${cyrus_sasl}"
  ];

  setVars = a.noDepEntry (''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${opal}/include/opal"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${evolution_data_server}/include/evolution-*)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libxml2}/include/libxml2"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${GConf}/include/gconf/2"

    export NIX_LDFLAGS="$NIX_LDFLAGS -lopal"
    for i in ${evolution_data_server}/lib/lib*.so; do
      file="$(basename "$i" .so)"
      bn="''${file#lib}"
      export NIX_LDFLAGS="$NIX_LDFLAGS -l$bn"
    done
  '');

  meta = {
    description = "Ekiga SIP client";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "mirror://gnome/sources/ekiga";
    };
  };
}) x

