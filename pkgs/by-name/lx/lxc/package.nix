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
  version = "6.0.3";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-h41lcHGjJmIH28XRpM0gdFsOQOCLSWevSLfvQ7gIf7Q=";
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

    # Fix hardcoded path of lxc-user-nic
    # This is needed to use unprivileged containers
    ./user-nic.diff
  ];

  mesonFlags = [
    "-Dinstall-init-files=true"
    "-Dinstall-state-dirs=false"
    "-Dspecfile=false"
    "-Dtools-multicall=true"
    "-Dtools=false"
    "-Dusernet-config-path=/etc/lxc/lxc-usernet"
    "-Ddistrosysconfdir=${placeholder "out"}/etc/lxc"
    "-Dsystemd-unitdir=${placeholder "out"}/lib/systemd/system"
  ];

  # /run/current-system/sw/share
  postInstall = ''
    substituteInPlace $out/etc/lxc/lxc --replace-fail "$out/etc/lxc" "/etc/lxc"
    substituteInPlace $out/libexec/lxc/lxc-net --replace-fail "$out/etc/lxc" "/etc/lxc"

    substituteInPlace $out/share/lxc/templates/lxc-download --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/templates/lxc-local --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/templates/lxc-oci --replace-fail "$out/share" "/run/current-system/sw/share"

    substituteInPlace $out/share/lxc/config/common.conf --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/config/userns.conf --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/config/oci.common.conf --replace-fail "$out/share" "/run/current-system/sw/share"
  '';

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    tests = {
      incus-lts = nixosTests.incus-lts.container;
      lxc = nixosTests.lxc;
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
