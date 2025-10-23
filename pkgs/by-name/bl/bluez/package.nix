{
  lib,
  stdenv,
  alsa-lib,
  autoreconfHook,
  bluez-headers,
  dbus,
  docutils,
  ell,
  enableExperimental ? false,
  fetchurl,
  glib,
  json_c,
  libical,
  pkg-config,
  python3Packages,
  readline,
  udev,
  # Test gobject-introspection instead of pygobject because the latter
  # causes an infinite recursion.
  gobject-introspection,
  buildPackages,
  installTests ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  gitUpdater,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluez";
  inherit (bluez-headers) version src;

  patches = [
    (fetchurl {
      name = "static.patch";
      url = "https://lore.kernel.org/linux-bluetooth/20250703182908.2370130-1-hi@alyssa.is/raw";
      hash = "sha256-4Yz3ljsn2emJf+uTcJO4hG/YXvjERtitce71TZx5Hak=";
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
    autoreconfHook
    docutils
    pkg-config
    python3Packages.pygments
    python3Packages.wrapPython
    udevCheckHook
  ];

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional installTests "test";

  postPatch = ''
    substituteInPlace tools/hid2hci.rules \
      --replace-fail /sbin/udevadm ${udev}/bin/udevadm \
      --replace-fail "hid2hci " "$out/lib/udev/hid2hci "
  ''
  +
    # Disable some tests:
    # - test-mesh-crypto depends on the following kernel settings:
    #   CONFIG_CRYPTO_[USER|USER_API|USER_API_AEAD|USER_API_HASH|AES|CCM|AEAD|CMAC]
    # - test-vcp is flaky (?), see:
    #     - https://github.com/bluez/bluez/issues/683
    #     - https://github.com/bluez/bluez/issues/726
    ''
      skipTest() {
        if [[ ! -f unit/$1.c ]]; then
          echo "unit/$1.c no longer exists"
          false
        fi

        echo 'int main() { return 77; }' > unit/$1.c
      }

      skipTest test-mesh-crypto
      skipTest test-vcp
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
    (lib.enableFeature (lib.elem "libsystemd" udev.meta.pkgConfigModules) "systemd")
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
  doInstallCheck = true;

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
    mainProgram = "btinfo";
    inherit (bluez-headers.meta)
      changelog
      description
      homepage
      license
      maintainers
      platforms
      ;
  };
})
