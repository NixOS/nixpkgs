{ withGUI ? true
, stdenv
, lib
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
, libxkbfile
, libXi
, libXtst
, libXrandr
, libXinerama
, xkeyboardconfig
, xinput
, avahi-compat

  # MacOS / darwin
, ApplicationServices
, Carbon
, Cocoa
, CoreServices
, ScreenSaver
}:

stdenv.mkDerivation rec {
  pname = "synergy";
  version = "1.14.5.17";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = version;
    sha256 = "sha256-9B6KPa1TsS4khCf7ccmwQZJ1KDEuLNw/W0PScYCgtlE=";
    fetchSubmodules = true;
  };

  patches = [
    # Without this OpenSSL from nixpkgs is not detected
    ./darwin-non-static-openssl.patch
    # We cannot include UserNotifications because of a build failure in the Apple SDK.
    # The functions used from it are already implicitly included anyways.
    ./darwin-no-UserNotifications-includes.patch
  ];

  postPatch = ''
    substituteInPlace src/gui/src/SslCertificate.cpp \
      --replace 'kUnixOpenSslCommand[] = "openssl";' 'kUnixOpenSslCommand[] = "${openssl}/bin/openssl";'
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace src/lib/synergy/unix/AppUtilUnix.cpp \
      --replace "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboardconfig}/share/X11/xkb/rules/evdev.xml"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional withGUI wrapQtAppsHook;

  buildInputs = [
    qttools # Used for translations even when not building the GUI
    openssl
    pcre
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
    libXinerama
    libxkbfile
    xinput
    avahi-compat
    gdk-pixbuf
    libnotify
  ];

  # Silences many warnings
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-inconsistent-missing-override";

  cmakeFlags = lib.optional (!withGUI) "-DSYNERGY_BUILD_LEGACY_GUI=OFF"
    ++ lib.optional stdenv.isDarwin "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.targetPlatform.darwinSdkVersion}";

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    bin/unittests
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/{synergyc,synergys,synergyd,syntool} $out/bin/
  '' + lib.optionalString withGUI ''
    cp bin/synergy $out/bin/
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp ../res/synergy.svg $out/share/icons/hicolor/scalable/apps/
    substitute ../res/synergy.desktop $out/share/applications/synergy.desktop \
      --replace "/usr/bin" "$out/bin"
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r bundle/Synergy.app $out/Applications
    ln -s $out/bin $out/Applications/Synergy.app/Contents/MacOS
  '' + ''
    runHook postInstall
  '';

  dontWrapQtApps = lib.optional (!withGUI) true;

  meta = with lib; {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = "https://symless.com/synergy";
    changelog = "https://github.com/symless/synergy-core/blob/${version}/ChangeLog";
    mainProgram = lib.optionalString (!withGUI) "synergyc";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ talyz ivar ];
    platforms = platforms.unix;
  };
}
