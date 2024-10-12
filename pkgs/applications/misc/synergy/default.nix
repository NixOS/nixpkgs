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
, libICE
, libSM
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
, UserNotifications
}:

stdenv.mkDerivation rec {
  pname = "synergy";
  version = "1.14.6.19-stable";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = version;
    hash = "sha256-0QqklfSsvcXh7I2jaHk82k0nY8gQOj9haA4WOjGqBqY=";
    fetchSubmodules = true;
  };

  patches = [
    # Without this OpenSSL from nixpkgs is not detected
    ./darwin-non-static-openssl.patch
  ];

  postPatch = ''
    substituteInPlace src/gui/src/SslCertificate.cpp \
      --replace 'kUnixOpenSslCommand[] = "openssl";' 'kUnixOpenSslCommand[] = "${openssl}/bin/openssl";'
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ApplicationServices
    Carbon
    Cocoa
    CoreServices
    ScreenSaver
    UserNotifications
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linux
    libselinux
    libsepol
    libICE
    libSM
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
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-inconsistent-missing-override";

  cmakeFlags = lib.optional (!withGUI) "-DSYNERGY_BUILD_LEGACY_GUI=OFF"
    # NSFilenamesPboardType is deprecated in 10.14+
    ++ lib.optional stdenv.hostPlatform.isDarwin "-DCMAKE_OSX_DEPLOYMENT_TARGET=${if stdenv.hostPlatform.isAarch64 then "10.13" else stdenv.hostPlatform.darwinSdkVersion}";

  doCheck = true;

  checkPhase = ''
    runHook preCheck
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # filter out tests failing with sandboxing on darwin
    export GTEST_FILTER=-ServerConfigTests.serverconfig_will_deem_equal_configs_with_same_cell_names:NetworkAddress.hostname_valid_parsing
  '' + ''
    bin/unittests
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/{synergyc,synergys,synergyd,syntool} $out/bin/
  '' + lib.optionalString withGUI ''
    cp bin/synergy $out/bin/
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp ../res/synergy.svg $out/share/icons/hicolor/scalable/apps/
    substitute ../res/synergy.desktop $out/share/applications/synergy.desktop \
      --replace "/usr/bin" "$out/bin"
  '' + lib.optionalString (stdenv.hostPlatform.isDarwin && withGUI) ''
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
    maintainers = with maintainers; [ talyz ];
    platforms = platforms.unix;
  };
}
