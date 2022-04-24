{ withGUI ? true
, stdenv
, lib
, fetchpatch
, fetchFromGitHub
, wrapQtAppsHook

, cmake
, openssl
, pcre
, util-linux
, libselinux
, libsepol
, pkg-config
, gdk-pixbuf
, libnotify
, qttools
, xlibsWrapper
, libX11
, libXi
, libXtst
, libXrandr
, xinput
, avahi-compat

# macOS / darwin
, ApplicationServices
, Carbon
, Cocoa
, CoreServices
, ScreenSaver
}:

stdenv.mkDerivation rec {
  pname = "synergy";
  version = "1.14.1.32";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = "${version}-stable";
    fetchSubmodules = true;
    sha256 = "123p75rm22vb3prw1igh0yii2y4bvv7r18iykfvmnr41hh4w7z2p";
  };

  patches = [ ./macos_build_fix.patch ];

  postPatch = ''
    substituteInPlace src/gui/src/SslCertificate.cpp \
      --replace 'kUnixOpenSslCommand[] = "openssl";' 'kUnixOpenSslCommand[] = "${openssl}/bin/openssl";'
  '';

  cmakeFlags = lib.optionals (!withGUI) [
    "-DSYNERGY_BUILD_LEGACY_GUI=OFF"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.09"
  ];
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-inconsistent-missing-override";

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  dontWrapQtApps = true;

  buildInputs = [
    openssl
    pcre
  ] ++ lib.optionals withGUI [
    qttools
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    Carbon
    Cocoa
    CoreServices
    ScreenSaver
  ] ++ lib.optionals stdenv.isLinux [
    util-linux
    libselinux
    libsepol
    xlibsWrapper
    libX11
    libXi
    libXtst
    libXrandr
    xinput
    avahi-compat
    gdk-pixbuf
    libnotify
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
    homepage = "https://symless.com/synergy";
    license = licenses.gpl2;
    maintainers = with maintainers; [ talyz ];
    platforms = platforms.all;
  };
}
