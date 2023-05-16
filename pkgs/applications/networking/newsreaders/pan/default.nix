{ spellChecking ? true
, lib
, stdenv
<<<<<<< HEAD
, fetchFromGitLab
, autoreconfHook
, pkg-config
, gtk3
, gtkspell3
, gmime3
=======
, fetchurl
, pkg-config
, gtk3
, gtkspell3
, gmime2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.154";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o+JFUraSoQ0HDmldHvTX+X7rl2L4n4lJmI4UFZrsfkQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config gettext intltool itstool libxml2 makeWrapper ];

  buildInputs = [ gtk3 gmime3 libnotify gnutls ]
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
