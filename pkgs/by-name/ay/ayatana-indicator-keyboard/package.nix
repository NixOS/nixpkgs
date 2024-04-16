{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, nixosTests
, accountsservice
, cmake
, glib
, intltool
, libayatana-common
, libX11
, libxkbcommon
, libxklavier
, lomiri
, pkg-config
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-keyboard";
  version = "24.2.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-keyboard";
    rev = finalAttrs.version;
    hash = "sha256-yrBASpZlO6BEuFl31uR9z2ghuF+9HIkfdMsxzWbnRJA=";
  };

  postPatch = ''
    # Queries systemd user unit dir via pkg_get_variable, can't override prefix
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail 'XDG_AUTOSTART_DIR "/etc' 'XDG_AUTOSTART_DIR "''${CMAKE_INSTALL_FULL_SYSCONFDIR}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    intltool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    lomiri.cmake-extras
    glib
    libayatana-common
    libX11
    libxkbcommon
    libxklavier
    systemd
  ];

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
  ];

  # dlopens different libraries for DE-specific behaviour
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib"
    )
  '';

  passthru = {
    ayatana-indicators = [ "ayatana-indicator-keyboard" ];
    tests.vm = nixosTests.ayatana-indicators;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Ayatana Indicator Keyboard Applet";
    longDescription = ''
      A keyboard indicator, which should show as an
      icon in the top panel of indicator-aware desktop environments.

      It can be used to switch key layouts or languages, and helps the user
      identifying which layouts are currently in use.
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-keyboard";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-keyboard/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
})
