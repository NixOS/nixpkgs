{ lib, stdenv
, pkg-config
, python3
, fetchFromGitLab
, gtk3
, glib
, gdbm
, gtkspell3
, ofono
, itstool
, libayatana-appindicator-gtk3
, perlPackages
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "modem-manager-gui";
  version = "0.0.20";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "modem-manager-gui";
    rev = "upstream%2F${version}";
    sha256 = "1pjx4rbsxa7gcs628yjkwb0zqrm5xq8pkmp0cfk4flfk1ryflmgr";
  };

  nativeBuildInputs = [
    pkg-config
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
    libayatana-appindicator-gtk3
  ];

  postPatch = ''
    patchShebangs man/manhelper.py
  '';

  meta = with lib; {
    description = "An app to send/receive SMS, make USSD requests, control mobile data usage and more";
    longDescription = ''
      A simple GTK based GUI compatible with Modem manager, Wader and oFono
      system services able to control EDGE/3G/4G broadband modem specific
      functions. You can check balance of your SIM card, send or receive SMS
      messages, control mobile traffic consumption and more.
    '';
    homepage = "https://linuxonly.ru/page/modem-manager-gui";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ahuzik galagora ];
    platforms = platforms.linux;
  };
}
