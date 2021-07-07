{ lib, mkDerivation, fetchFromGitHub, cmake
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca-qt5, libXScrnSaver, hunspell
, libsecret, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
, usrsctp

# Voice messages
, voiceMessagesSupport ? true
, gst_all_1
}:

mkDerivation rec {
  pname = "psi-plus";
  version = "1.5.1520";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "0cj811qv0n8xck2qrnps2ybzrpvyjqz7nxkyccpaivq6zxj6mc12";
  };

  cmakeFlags = [
    "-DENABLE_PLUGINS=ON"
  ];

  nativeBuildInputs = [ cmake qttools ];

  buildInputs = [
    qtbase qtmultimedia qtx11extras qtwebengine
    libidn qca-qt5 libXScrnSaver hunspell
    libsecret libgcrypt libotr html-tidy libgpgerror libsignal-protocol-c
    usrsctp
  ] ++ lib.optionals voiceMessagesSupport [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  preFixup = lib.optionalString voiceMessagesSupport ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  meta = with lib; {
    homepage = "https://psi-plus.com";
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej misuzu ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
