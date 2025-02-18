{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
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
  version = "2.14";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/snapshot/ofono-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-7hYGSU8mEu9MfKAA0vR1tm/l46hHQmpZSYfMNkces5c=";
  };

  patches = [
    (fetchpatch {
      name = "0001-ofono-CVE-2024-7539.patch";
      url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/patch/?id=389e2344f86319265fb72ae590b470716e038fdc";
      hash = "sha256-jaZswtkWa8A9WlmjUxcwWtU2uUX5+g8m2Y/60Lb9C5Q=";
    })

    (fetchpatch {
      name = "0002-ofono-CVE-2024-7540-through-7542.patch";
      url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/patch/?id=29ff6334b492504ace101be748b256e6953d2c2f";
      hash = "sha256-3iKG+5AQUVO4alZd3stTpyanwI2IfKbVTzatflMsurY=";
    })

    (fetchpatch {
      name = "0003-ofono-Ensure-decode_hex_own_buf-valid-buffer.patch";
      url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/patch/?id=1e2a768445aecfa0a0e9c788651a9205cfd3744f";
      hash = "sha256-MD+LMnVK1JcVU47jQ+X0AHe8c/WqjsFycDroONE9ZLM=";
    })

    ./0001-Search-connectors-in-OFONO_PLUGIN_PATH.patch
  ];

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

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

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
