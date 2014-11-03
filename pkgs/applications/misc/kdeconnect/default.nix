{ stdenv, fetchurl, gettext, kdelibs, libXtst, makeWrapper, qca2, qca2_ossl, qjson }:

stdenv.mkDerivation rec {
  name = "kdeconnect-${version}";
  version = "0.7.2";

  src = fetchurl {
    url = "http://download.kde.org/unstable/kdeconnect/${version}/src/kdeconnect-kde-${version}.tar.xz";
    sha256 = "1v7sicgy39n8pn7nzq9f7lkmwbcvavhy3b66agyhxwmyzz6mcd4g";
  };

  buildInputs = [ gettext kdelibs libXtst makeWrapper qca2 qca2_ossl qjson ];

  postInstall = ''
    wrapProgram $out/lib/kde4/libexec/kdeconnectd --prefix QT_PLUGIN_PATH : ${qca2_ossl}/lib/qt4/plugins
  '';

  meta = with stdenv.lib; {
    description = "A tool to connect and sync your devices with KDE";
    longDescription = ''
        The corresponding Android app, "KDE Connect", is available in
        F-Droid and Google play and has the following features:

        - Share files and URLs to KDE from any app
        - Clipboard share: copy from or to your desktop
        - Notifications sync (4.3+): Read your Android notifications from KDE
        - Multimedia remote control: Use your phone as a remote control
        - WiFi connection: no usb wire or bluetooth needed
        - RSA Encryption: your information is safe 
    '';
    license = licenses.gpl2;
    homepage = https://projects.kde.org/projects/playground/base/kdeconnect-kde;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
