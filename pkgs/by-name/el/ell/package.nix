{ lib, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, dbus
, sysctl
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.70";

  outputs = [ "out" "dev" ];
  separateDebugInfo = true;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    rev = version;
    hash = "sha256-2JPmS+OuK1cQyBRR0kDDWXBDUWUZuK/vsQ483GLu/S0=";
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

  # tests sporadically fail on musl
  doCheck = !stdenv.hostPlatform.isMusl;

  passthru = {
    updateScript = gitUpdater {
      url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    };
  };

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    description = "Embedded Linux Library";
    longDescription = ''
      The Embedded Linux* Library (ELL) provides core, low-level functionality for system daemons. It typically has no dependencies other than the Linux kernel, C standard library, and libdl (for dynamic linking). While ELL is designed to be efficient and compact enough for use on embedded Linux platforms, it is not limited to resource-constrained systems.
    '';
    changelog = "https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ChangeLog?h=${version}";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
