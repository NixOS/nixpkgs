{ stdenv
, pkgconfig
, python3
, fetchhg
, fetchpatch
, gtk3
, glib
, gdbm
, gtkspell3
, ofono
, itstool
, libappindicator-gtk3
, perlPackages
, glibcLocales
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "modem-manager-gui";
  version = "0.0.19.1";

  src = fetchhg {
    url = "https://linuxonly@bitbucket.org/linuxonly/modem-manager-gui";
    rev = "version ${version}";
    sha256 = "11iibh36567814h2bz41sa1072b86p1l13xyj670pwkh9k8kw8fd";
  };

  patches = [
    # Fix docs build
    (fetchpatch {
      url = "https://bitbucket.org/linuxonly/modem-manager-gui/commits/68fb09c12413b7de9b7477cbf4241c3527568325/raw";
      sha256 = "033nrlhjlk0zvadv5g9n2id53ajagswf77mda0ixnrskyi7wiig7";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    python3
    perlPackages.Po4a
    itstool
    meson
    ninja
  ];

  buildInputs = [
    gtk3
    glib
    gdbm
    gtkspell3
    ofono
    libappindicator-gtk3
  ];

  postPatch = ''
    patchShebangs man/manhelper.py
  '';

  meta = with stdenv.lib; {
    description = "An app to send/receive SMS, make USSD requests, control mobile data usage and more";
    longDescription = ''
      A simple GTK based GUI compatible with Modem manager, Wader and oFono
      system services able to control EDGE/3G/4G broadband modem specific
      functions. You can check balance of your SIM card, send or receive SMS
      messages, control mobile traffic consumption and more.
    '';
    homepage = "https://linuxonly.ru/page/modem-manager-gui";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ahuzik ];
    platforms = platforms.linux;
  };
}
