{
  lib,
  stdenv,
  alsa-lib,
  dbus,
  docutils,
  ell,
  enableExperimental ? false,
  fetchurl,
  glib,
  json_c,
  libical,
  pkg-config,
  python3,
  readline,
  systemdMinimal,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluez";
  version = "5.75";

  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz";
    hash = "sha256-mIyzxFUfbjpmdwilePXKn5P8iWUI+Y8IcJvk+KsDPC8=";
  };

  patches =
    # Disable one failing test with musl libc, also seen by alpine
    # https://github.com/bluez/bluez/issues/726
    lib.optional (stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_64) (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/main/bluez/disable_aics_unit_testcases.patch?id=8e96f7faf01a45f0ad8449c1cd825db63a8dfd48";
      hash = "sha256-1PJkipqBO3qxxOqRFQKfpWlne1kzTCgtnTFYI1cFQt4=";
    });

  buildInputs = [
    alsa-lib
    dbus
    ell
    glib
    json_c
    libical
    python3
    readline
    udev
  ];

  nativeBuildInputs = [
    docutils
    pkg-config
    python3.pkgs.wrapPython
  ];

  outputs = [
    "out"
    "dev"
    "test"
  ];

  postPatch =
    ''
      substituteInPlace tools/hid2hci.rules \
        --replace /sbin/udevadm ${systemdMinimal}/bin/udevadm \
        --replace "hid2hci " "$out/lib/udev/hid2hci "
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
      pythonPath = with python3.pkgs; [
        dbus-python
        pygobject3
      ];
    in
    ''
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
    '';

  enableParallelBuilding = true;

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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
