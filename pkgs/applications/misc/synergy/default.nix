{ stdenv, lib, fetchpatch, fetchFromGitHub, cmake, openssl, qttools
, ApplicationServices, Carbon, Cocoa, CoreServices, ScreenSaver
, xlibsWrapper, libX11, libXi, libXtst, libXrandr, xinput, avahi-compat
, withGUI ? true, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "synergy";
  version = "1.13.1.41";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = "${version}-stable";
    fetchSubmodules = true;
    sha256 = "1phg0szc9g018zxs5wbys4drzq1cdhyzajfg45l6a3fmi6qdi1kw";
  };

  patches = lib.optional stdenv.isDarwin ./macos_build_fix.patch;

  postPatch = ''
    substituteInPlace src/gui/src/SslCertificate.cpp \
      --replace 'kUnixOpenSslCommand[] = "openssl";' 'kUnixOpenSslCommand[] = "${openssl}/bin/openssl";'
  '';

  cmakeFlags = lib.optional (!withGUI) "-DSYNERGY_BUILD_LEGACY_GUI=OFF";

  nativeBuildInputs = [ cmake ] ++ lib.optional withGUI wrapQtAppsHook;

  dontWrapQtApps = true;

  buildInputs = [
    openssl
  ] ++ lib.optionals withGUI [
    qttools
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices Carbon Cocoa CoreServices ScreenSaver
  ] ++ lib.optionals stdenv.isLinux [
    xlibsWrapper libX11 libXi libXtst libXrandr xinput avahi-compat
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/{synergyc,synergys,synergyd,syntool} $out/bin/
  '' + lib.optionalString withGUI ''
    cp bin/synergy $out/bin/
    wrapQtApp $out/bin/synergy
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ../res/synergy.svg $out/share/icons/hicolor/scalable/apps/
    mkdir -p $out/share/applications
    substitute ../res/synergy.desktop $out/share/applications/synergy.desktop --replace /usr/bin $out/bin
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications/
    mv bundle/Synergy.app $out/Applications/
    ln -s $out/bin $out/Applications/Synergy.app/Contents/MacOS
  '';

  doCheck = true;
  checkPhase = "bin/unittests";

  meta = with lib; {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = "https://synergy-project.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ talyz ];
    platforms = platforms.all;
  };
}
