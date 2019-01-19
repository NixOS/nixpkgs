{ stdenv, fetchurl, fetchFromGitHub
, qmake, qtbase, qtquickcontrols, qtsvg
, python3, pyotherside, ncurses
, pcsclite, yubikey-personalization
, yubikey-manager, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "yubioath-desktop";
  version = "4.3.4";

  src = fetchurl {
    url = "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-${version}.tar.gz";
    sha256 = "0hb7j71032sigs8zd5r8yr0m59sjkb24vhs2l4jarpvj8q7hv30d";
  };

  doCheck = false;

  buildInputs = [ stdenv qtbase qtquickcontrols pyotherside python3 ];

  nativeBuildInputs = [ qmake makeWrapper python3.pkgs.wrapPython ];

  postPatch = ''
    substituteInPlace deployment.pri \
      --replace '/usr/bin' "$out/bin"
  '';

  pythonPath = [ yubikey-manager ];

  # Need LD_PRELOAD for libykpers as the Nix cpython disables ctypes.cdll.LoadLibrary
  # support that the yubicommon library uses to load libykpers

  postInstall = ''
    buildPythonPath "$out $pythonPath"
    wrapProgram $out/bin/yubioath-desktop \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --prefix LD_PRELOAD : "${yubikey-personalization}/lib/libykpers-1.so" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.getLib pcsclite}/lib:${yubikey-personalization}/lib"

      mkdir -p $out/share/applications
      cp resources/yubioath-desktop.desktop \
        $out/share/applications/yubioath-desktop.desktop
      mkdir -p $out/share/yubioath/icons
      cp resources/icons/*.{icns,ico,png,xpm} $out/share/yubioath/icons
      substituteInPlace $out/share/applications/yubioath-desktop.desktop \
        --replace 'Exec=yubioath-desktop' "Exec=$out/bin/yubioath-desktop" \
  '';

  meta = with stdenv.lib; {
    description = "Yubikey Desktop Authenticator";

    homepage = https://www.yubico.com/support/knowledge-base/categories/articles/yubico-authenticator-download/;

    license = stdenv.lib.licenses.gpl3;
    maintainers = with maintainers; [ mic92 ];
  };
}
