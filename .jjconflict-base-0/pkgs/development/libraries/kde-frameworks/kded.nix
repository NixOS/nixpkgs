{
  mkDerivation,
  lib,
  propagate,
  wrapGAppsHook3,
  extra-cmake-modules,
  kdoctools,
  gsettings-desktop-schemas,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kservice,
  qtbase,
}:

mkDerivation {
  pname = "kded";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapGAppsHook3
  ];
  buildInputs = [
    gsettings-desktop-schemas
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kservice
    qtbase
  ];
  outputs = [
    "out"
    "dev"
  ];
  setupHook = propagate "out";
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
