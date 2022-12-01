{ spellChecking ? true
, lib
, stdenv
, fetchurl
, pkg-config
, gtk3
, gtkspell3
, gmime2
, gettext
, intltool
, itstool
, libxml2
, libnotify
, gnutls
, makeWrapper
, gnupg
, gnomeSupport ? true
, libsecret
, gcr
}:

stdenv.mkDerivation rec {
  pname = "pan";
  version = "0.146";

  src = fetchurl {
    url = "https://pan.rebelbase.com/download/releases/${version}/source/pan-${version}.tar.bz2";
    sha256 = "17agd27sn4a7nahvkpg0w39kv74njgdrrygs74bbvpaj8rk2hb55";
  };

  patches = [
    # Take <glib.h>, <gmime.h>, "gtk-compat.h" out of extern "C"
    ./move-out-of-extern-c.diff
  ];

  nativeBuildInputs = [ pkg-config gettext intltool itstool libxml2 makeWrapper ];

  buildInputs = [ gtk3 gmime2 libnotify gnutls ]
    ++ lib.optional spellChecking gtkspell3
    ++ lib.optionals gnomeSupport [ libsecret gcr ];

  configureFlags = [
    "--with-dbus"
    "--with-gtk3"
    "--with-gnutls"
    "--enable-libnotify"
  ] ++ lib.optional spellChecking "--with-gtkspell"
  ++ lib.optional gnomeSupport "--enable-gkr";

  postInstall = ''
    wrapProgram $out/bin/pan --suffix PATH : ${gnupg}/bin
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A GTK-based Usenet newsreader good at both text and binaries";
    homepage = "http://pan.rebelbase.com/";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2Only fdl11Only ];
  };
}
