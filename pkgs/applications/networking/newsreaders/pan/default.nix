{ spellChecking ? true
, lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, pkg-config
, gtk3
, gtkspell3
, gmime3
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
