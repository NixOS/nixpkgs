{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  docbook2x,
  libapparmor,
  libcap,
  libseccomp,
  libselinux,
  meson,
  ninja,
  nixosTests,
  openssl,
  pkg-config,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxc";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fJMNdMXlV1z9q1pMDh046tNmLDuK6zh6uPahTWzWMvc=";
  };

  nativeBuildInputs = [
    docbook2x
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    libapparmor
    libcap
    libseccomp
    libselinux
    openssl
    systemd
  ];

  patches = [
    # fix docbook2man version detection
    ./docbook-hack.patch
  ];

  mesonFlags = [
    "-Dinstall-init-files=false"
    "-Dinstall-state-dirs=false"
    "-Dspecfile=false"
    "-Dtools-multicall=true"
    "-Dtools=false"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    tests = {
      incus-legacy-init = nixosTests.incus.container-legacy-init;
      incus-systemd-init = nixosTests.incus.container-systemd-init;
      lxd = nixosTests.lxd.container;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(6.0.*)"
      ];
    };
  };

  meta = {
    homepage = "https://linuxcontainers.org/";
    description = "Userspace tools for Linux Containers, a lightweight virtualization system";
    license = lib.licenses.gpl2;

    longDescription = ''
      LXC containers are often considered as something in the middle between a chroot and a
      full fledged virtual machine. The goal of LXC is to create an environment as close as
      possible to a standard Linux installation but without the need for a separate kernel.
    '';

    platforms = lib.platforms.linux;
    maintainers = lib.teams.lxc.members;
  };
})
