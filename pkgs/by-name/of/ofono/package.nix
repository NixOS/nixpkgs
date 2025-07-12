{
  lib,
  stdenv,
  fetchzip,
  testers,
  autoreconfHook,
  pkg-config,
  glib,
  dbus,
  ell,
  systemd,
  bluez,
  mobile-broadband-provider-info,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ofono";
  version = "2.17";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/snapshot/ofono-${finalAttrs.version}.tar.gz";
    hash = "sha256-VJhLJeC1pwXuAadKvYPel6Xb3RZG4vwDhhKefRVrt3Y=";
  };

  patches = [ ./0001-Search-connectors-in-OFONO_PLUGIN_PATH.patch ];

  postPatch = ''
    patchShebangs tools/provisiontool
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    glib
    dbus
    ell
    systemd
    bluez
    mobile-broadband-provider-info
  ];

  configureFlags = [
    (lib.strings.withFeatureAs true "dbusconfdir" "${placeholder "out"}/share")
    (lib.strings.withFeatureAs true "systemdunitdir" "${placeholder "out"}/lib/systemd/system")
    (lib.strings.enableFeature true "external-ell")
    "--sysconfdir=/etc"
  ];

  installFlags = [ "sysconfdir=${placeholder "out"}/etc" ];

  enableParallelBuilding = true;
  enableParallelChecking = false;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Infrastructure for building mobile telephony (GSM/UMTS) applications";
    homepage = "https://git.kernel.org/pub/scm/network/ofono/ofono.git";
    changelog = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/plain/ChangeLog?h=${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "ofonod";
    pkgConfigModules = [
      "ofono"
    ];
  };
})
