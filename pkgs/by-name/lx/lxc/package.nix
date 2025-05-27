{
  lib,
  stdenv,
  fetchFromGitHub,

  bashInteractive,
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

  fetchpatch,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxc";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmL568PprrpIWTVCkScXHEzTZ+NduSH4r8ETnz4NY64=";
  };

  nativeBuildInputs = [
    docbook2x
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    # some hooks use compgen
    bashInteractive
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

    # Fixes https://github.com/zabbly/incus/issues/81
    (fetchpatch {
      name = "4536.patch";
      url = "https://patch-diff.githubusercontent.com/raw/lxc/lxc/pull/4536.patch";
      hash = "sha256-yEqK9deO2MhfPROPfBw44Z752Mc5bR8DBKl1KrGC+5c=";
    })
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
        "v(6\\.0\\.*)"
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
    teams = [ lib.teams.lxc ];
  };
})
