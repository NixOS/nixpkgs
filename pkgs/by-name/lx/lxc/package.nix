{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

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

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxc";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eB68l7SmVxJViGmVlVtEXVD+cRtr4WqOrA8b9ImQ89g=";
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

    # CVE-2026-100395, GHSA-r23j-58gg-pjjc: lxc-copy followed symlinks while
    # rewriting /etc/hostname in a cloned rootfs. Backported from git until a
    # release containing the fix is available.
    (fetchpatch {
      name = "CVE-2026-100395-1-hostname-open.patch";
      url = "https://github.com/lxc/lxc/commit/6424a91a55efc54edc25ca46e9165bd9f35b50b7.patch";
      hash = "sha256-trkFDYxKO4g/7KH4PEwvjDS2+aKja4MXI5xrfXbWFT4=";
    })

    # follow-up to the same fix: keep fopen()'s truncation behavior
    (fetchpatch {
      name = "CVE-2026-100395-2-hostname-truncate.patch";
      url = "https://github.com/lxc/lxc/commit/fa12709a79c2b63b3918297d7505108fcc840eb6.patch";
      hash = "sha256-r0vEyUwG2NTiRzlVoSady2rro2S8wsF3AJnZEGIx7Ik=";
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
    };

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://linuxcontainers.org/lxc/";
    changelog = "https://github.com/lxc/lxc/releases/tag/v${finalAttrs.version}";
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
