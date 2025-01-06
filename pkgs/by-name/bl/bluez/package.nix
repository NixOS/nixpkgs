{
  lib,
  stdenv,
  alsa-lib,
  dbus,
  docutils,
  ell,
  enableExperimental ? false,
  fetchpatch,
  fetchurl,
  glib,
  json_c,
  libical,
  pkg-config,
  python3Packages,
  readline,
  systemdMinimal,
  udev,
  # Test gobject-introspection instead of pygobject because the latter
  # causes an infinite recursion.
  gobject-introspection,
  buildPackages,
  installTests ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluez";
  version = "5.79";

  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz";
    hash = "sha256-QWSlMDqfcccPSMA/9gvjQjG1aNk6mtXnmSjTTmqg6oo=";
  };

  patches = [
    (fetchpatch {
      name = "musl.patch";
      url = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/patch/?id=9d69dba21f1e46b34cdd8ae27fec11d0803907ee";
      hash = "sha256-yMXPRPK8aT+luVoXNxx9zIa4c6E0BKYKS55DCfr8EQ0=";
    })
  ];

  buildInputs = [
    alsa-lib
    dbus
    ell
    glib
    json_c
    libical
    python3Packages.python
    readline
    udev
  ];

  nativeBuildInputs = [
    docutils
    pkg-config
    python3Packages.pygments
    python3Packages.wrapPython
  ];

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional installTests "test";

  postPatch =
    ''
      substituteInPlace tools/hid2hci.rules \
        --replace-fail /sbin/udevadm ${systemdMinimal}/bin/udevadm \
        --replace-fail "hid2hci " "$out/lib/udev/hid2hci "
    ''
    +
      # Disable some tests:
      # - test-mesh-crypto depends on the following kernel settings:
      #   CONFIG_CRYPTO_[USER|USER_API|USER_API_AEAD|USER_API_HASH|AES|CCM|AEAD|CMAC]
      ''
        if [[ ! -f unit/test-mesh-crypto.c ]]; then
          echo "unit/test-mesh-crypto.c no longer exists"
          false
        fi
        echo 'int main() { return 77; }' > unit/test-mesh-crypto.c
      '';

  configureFlags = [
    "--localstatedir=/var"
    (lib.enableFeature enableExperimental "experimental")
    (lib.enableFeature true "btpclient")
    (lib.enableFeature true "cups")
    (lib.enableFeature true "external-ell")
    (lib.enableFeature true "health")
    (lib.enableFeature true "hid2hci")
    (lib.enableFeature true "library")
    (lib.enableFeature true "logger")
    (lib.enableFeature true "mesh")
    (lib.enableFeature true "midi")
    (lib.enableFeature true "nfc")
    (lib.enableFeature true "pie")
    (lib.enableFeature true "sixaxis")
    # Set "deprecated" to provide ciptool, sdptool, and rfcomm (unmaintained);
    # superseded by new D-Bus APIs
    (lib.enableFeature true "deprecated")
    (lib.withFeatureAs true "dbusconfdir" "${placeholder "out"}/share")
    (lib.withFeatureAs true "dbussessionbusdir" "${placeholder "out"}/share/dbus-1/services")
    (lib.withFeatureAs true "dbussystembusdir" "${placeholder "out"}/share/dbus-1/system-services")
    (lib.withFeatureAs true "systemdsystemunitdir" "${placeholder "out"}/etc/systemd/system")
    (lib.withFeatureAs true "systemduserunitdir" "${placeholder "out"}/etc/systemd/user")
    (lib.withFeatureAs true "udevdir" "${placeholder "out"}/lib/udev")
  ];

  makeFlags = [
    "rulesdir=${placeholder "out"}/lib/udev/rules.d"
  ];

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = [
    "statedir=$(TMPDIR)/var/lib/bluetooth"
  ];

  doCheck = stdenv.hostPlatform.isx86_64;

  postInstall =
    let
      pythonPath = with python3Packages; [
        dbus-python
        pygobject3
      ];
    in
    ''
      # for bluez4 compatibility for NixOS
      mkdir $out/sbin
      ln -s ../libexec/bluetooth/bluetoothd $out/sbin/bluetoothd
      ln -s ../libexec/bluetooth/obexd $out/sbin/obexd

      # Add extra configuration
      rm $out/etc/bluetooth/{main,input,network}.conf
      ln -s /etc/bluetooth/main.conf $out/etc/bluetooth/main.conf

      # https://github.com/NixOS/nixpkgs/issues/204418
      ln -s /etc/bluetooth/input.conf $out/etc/bluetooth/input.conf
      ln -s /etc/bluetooth/network.conf $out/etc/bluetooth/network.conf

      # Add missing tools, ref https://git.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/bluez
      for files in $(find tools/ -type f -perm -755); do
        filename=$(basename $files)
        install -Dm755 tools/$filename $out/bin/$filename
      done
      install -Dm755 attrib/gatttool $out/bin/gatttool
    ''
    + lib.optionalString installTests ''
      mkdir -p $test/{bin,test}
      cp -a test $test
      pushd $test/test
      for t in \
              list-devices \
              monitor-bluetooth \
              simple-agent \
              test-adapter \
              test-device \
              test-thermometer \
              ; do
        ln -s ../test/$t $test/bin/bluez-$t
      done
      popd
      wrapPythonProgramsIn $test/test "$test/test ${toString pythonPath}"
    '';

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.kernel.org/pub/scm/bluetooth/bluez.git";
  };

  meta = {
    homepage = "https://www.bluez.org/";
    description = "Official Linux Bluetooth protocol stack";
    changelog = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/ChangeLog?h=${finalAttrs.version}";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
      lgpl21Plus
      mit
    ];
    mainProgram = "btinfo";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
