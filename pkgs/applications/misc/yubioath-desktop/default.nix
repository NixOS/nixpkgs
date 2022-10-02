{ lib
, stdenv
, fetchurl
, mkDerivation
, qmake
, qtbase
, qtquickcontrols2
, qtgraphicaleffects
, qtmultimedia
, python3
, pyotherside
, pcsclite
, yubikey-personalization
, yubikey-manager
, makeWrapper
}:

mkDerivation rec {
  pname = "yubioath-desktop";
  version = "5.1.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-${version}.tar.gz";
    hash = "sha256-Lm9F4eaG9T5brAV7XDAkoj0WClmXEYIhuUzh2rk0oc0=";
  };

  doCheck = false;

  buildInputs = [ qtbase qtquickcontrols2 qtgraphicaleffects qtmultimedia python3 ];

  nativeBuildInputs = [ qmake makeWrapper python3.pkgs.wrapPython ];

  postPatch = ''
    substituteInPlace QZXing/QZXing-components.pri \
      --replace 'target.path = $$PREFIX/lib' 'target.path = $$PREFIX/bin'
  '';

  pythonPath = [ yubikey-manager ];

  # Need LD_PRELOAD for libykpers as the Nix cpython disables ctypes.cdll.LoadLibrary
  # support that the yubicommon library uses to load libykpers

  postInstall = ''
    buildPythonPath "$out $pythonPath"
    wrapProgram $out/bin/yubioath-desktop \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --prefix QML2_IMPORT_PATH : "${pyotherside}/${qtbase.qtQmlPrefix}" \
      --prefix LD_PRELOAD : "${yubikey-personalization}/lib/libykpers-1.so" \
      --prefix LD_LIBRARY_PATH : "${lib.getLib pcsclite}/lib:${yubikey-personalization}/lib"

      mkdir -p $out/share/applications
      cp resources/com.yubico.yubioath.desktop \
        $out/share/applications/com.yubico.yubioath.desktop
      mkdir -p $out/share/yubioath/icons
      cp resources/icons/*.{icns,ico,png,svg} $out/share/yubioath/icons
      substituteInPlace $out/share/applications/com.yubico.yubioath.desktop \
        --replace 'Exec=yubioath-desktop' "Exec=$out/bin/yubioath-desktop" \
        --replace 'Icon=com.yubico.yubioath' "Icon=$out/share/yubioath/icons/com.yubico.yubioath.png"
  '';

  meta = with lib; {
    description = "Yubico Authenticator";
    longDescription = ''
      Application for generating Open Authentication (OATH) time-based TOTP and
      event-based HOTP one-time password codes, with the help of a YubiKey that
      protects the shared secrets.
    '';

    homepage = "https://developers.yubico.com/yubioath-desktop";
    downloadPage = "https://developers.yubico.com/yubioath-desktop/Releases/";
    changelog = "https://developers.yubico.com/yubioath-desktop/Release_Notes.html";

    license = lib.licenses.bsd2;
    maintainers = with maintainers; [ mic92 risson ];
  };
}
