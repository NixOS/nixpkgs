{ lib, stdenv, fetchurl, openssl, pkg-config, brotli
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
, withUnicode ? true, icu
, withZlib ? true, zlib
, withIPv6 ? true
, withDebug ? false
}:

stdenv.mkDerivation rec {
  pname = "znc";
  version = "1.8.2";

  src = fetchurl {
    url = "https://znc.in/releases/archive/${pname}-${version}.tar.gz";
    sha256 = "03fyi0j44zcanj1rsdx93hkdskwfvhbywjiwd17f9q1a7yp8l8zz";
  };

  nativeBuildInputs = [ pkg-config brotli ];

  buildInputs = [ openssl ]
    ++ lib.optional withPerl perl
    ++ lib.optional withPython python3
    ++ lib.optional withTcl tcl
    ++ lib.optional withCyrus cyrus_sasl
    ++ lib.optional withUnicode icu
    ++ lib.optional withZlib zlib;

  configureFlags = [
    (lib.enableFeature withPerl "perl")
    (lib.enableFeature withPython "python")
    (lib.enableFeature withTcl "tcl")
    (lib.withFeatureAs withTcl "tcl" "${tcl}/lib")
    (lib.enableFeature withCyrus "cyrus")
  ] ++ lib.optionals (!withIPv6) [ "--disable-ipv6" ]
    ++ lib.optionals withDebug [ "--enable-debug" ];

  enableParallelBuilding = true;

  # Sort html files to use reverse proxy correctly and create static gzip and brotli files.
  postInstall = ''
    mkdir -p $out/share/znc/html/{skinfiles/_default_,modfiles/global/webadmin,pub}
    ln -s $out/share/znc/webskins/_default_/pub/* -t $out/share/znc/html/pub
    ln -s $out/share/znc/webskins/_default_/pub/{External.png,global.css} -t $out/share/znc/html/skinfiles/_default_
    ln -s $out/share/znc/webskins/_default_/pub/robots.txt -t $out/share/znc/html
    rm $out/share/znc/html/pub/{External.png,favicon.ico,global.css,robots.txt}
    ln -s $out/share/znc/modules/webadmin/files/webadmin.{css,js} -t $out/share/znc/html/modfiles/global/webadmin
    ln -s $out/share/znc/webskins/dark-clouds/pub/{dark-clouds.css,clouds-header.jpg} -t $out/share/znc/html/pub
    ln -s $out/share/znc/webskins/forest/pub/{forest.css,forest-header.png} -t $out/share/znc/html/pub
    ln -s $out/share/znc/webskins/ice/pub/{ice.css,pagebg.gif,linkbg.jpg} -t $out/share/znc/html/pub
    find -L $out/share/znc/html -type f -regextype posix-extended -iregex '.*\.(css|js|txt)' \
      -exec gzip --best --keep --force {} ';' \
      -exec brotli --best --keep --no-copy-stat {} ';'
  '';

  meta = with lib; {
    description = "Advanced IRC bouncer";
    homepage = "https://wiki.znc.in/ZNC";
    maintainers = with maintainers; [ schneefux lnl7 ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
