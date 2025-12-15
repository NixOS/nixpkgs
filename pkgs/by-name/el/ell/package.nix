{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  dbus,
  sysctl,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.80";

  outputs = [
    "out"
    "dev"
  ];
  separateDebugInfo = true;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    rev = version;
    hash = "sha256-B7Dz5H49d8kQaHfPQt7Y3f9D6EdqLOBMK+378g4E46U=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  nativeCheckInputs = [
    dbus
    # required as the sysctl test works on some machines
    sysctl
  ];

  enableParallelBuilding = true;

  # Runs multiple dbus instances on the same port failing the bind.
  enableParallelChecking = false;

  # 'unit/test-hwdb' fails in the sandbox as it relies on
  # '/etc/udev/hwdb.bin' file presence in the sandbox. `nixpkgs` does
  # not provide it today in any form. Let's skip the test.
  env.XFAIL_TESTS = "unit/test-hwdb";

  # tests sporadically fail on musl
  doCheck = !stdenv.hostPlatform.isMusl;

  passthru = {
    updateScript = gitUpdater {
      url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    };
  };

  meta = {
    homepage = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    description = "Embedded Linux Library";
    longDescription = ''
      The Embedded Linux* Library (ELL) provides core, low-level functionality for system daemons. It typically has no dependencies other than the Linux kernel, C standard library, and libdl (for dynamic linking). While ELL is designed to be efficient and compact enough for use on embedded Linux platforms, it is not limited to resource-constrained systems.
    '';
    changelog = "https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ChangeLog?h=${version}";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mic92
      dtzWill
    ];
  };
}
