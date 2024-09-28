{
  python3,
  fetchFromGitHub,
  desktop-file-utils,
  shared-mime-info,
  qubes-linux-utils,
  pandoc,
  bash,
  patsh,
}:
let
  inherit (python3.pkgs) buildPythonApplication setuptools distutils qubes-core-qubesdb;
  version = "4.2.37";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-core-agent-linux";
    rev = "refs/tags/v${version}";
    hash = "sha256-BPIlym08pOer6IzdsJj2p5AChTSRsoIvjuMTaJSdvMs=";
  };
in
buildPythonApplication {
  inherit version src;
  pname = "qubes-core-agent-linux";
  format = "custom";

  nativeBuildInputs = [
    desktop-file-utils
    shared-mime-info
    pandoc
    setuptools
    distutils
    patsh
  ];

  propagatedBuildInputs = [
    qubes-linux-utils
    qubes-core-qubesdb
    bash
  ];

  buildFlags = ["all"];

  dontUsePypaInstall = true;
  # TODO: netvm wants everything, but most of those things need to be removed for NixOS.
  # It might make sense to drop default Makefile and copy everything we need only.
  installTargets = [
    "install-systemd-dropins"
    "install-systemd-networking-dropins"
    "install-init"
    "install-systemd"
    "install-common"
    "install-networking"
    "install-netvm"
  ];

  outputs = ["out" "man"];

  # Many things needs to be dropped from package, because they are heavily dependent on QubesOS infra.
  postInstall = ''
    mv $out/usr/bin $out/
    mkdir -p $man
    mv $out/usr/share $man/

    # NetworkManager doesn't accept such dropins on NixOS, they are rewritten
    # in qubes-dom0 module instead. As for non-nixos nix users... Its complicated, TODO.
    rm $out/usr/lib/NetworkManager/conf.d/{30-qubes.conf,31-randomize-mac.conf}
    mv $out/usr/lib/tmpfiles.d $out/lib/
    rm -d $out/usr/lib/{NetworkManager/{conf.d,},}

    rm -d $out/usr/

    # Symlink to /lib/qubes/qubes-setup-dnat-to-ns, needs to be either recreated (because it is broken),
    # or completely ignored (as it is now), as NixOS doesn't use dhclient, something else might call this hook.
    # qubes-dnat-to-ns hook setups dns dnat in sys-net.
    rm -rf $out/etc/dhclient.d

    # part of xen-domU setup
    rm $out/etc/systemd/system/xendriverdomain.service
    rm -d $out/etc/systemd/{system,}

    rm $out/lib/modules-load.d/qubes-core.conf
    rm -d $out/lib/modules-load.d

    patsh -f $out/etc/xen/scripts/vif-route-qubes -s ${builtins.storeDir}
    patsh -f $out/etc/xen/scripts/vif-qubes-nat.sh -s ${builtins.storeDir}

    # Many of those needs to be remade for NixOS, I doubt they work, but it is not required for dom0
    for name in bind-dirs.sh control-printer-icon.sh functions misc-post.sh misc-post-stop.sh mount-dirs.sh \
      network-proxy-setup.sh network-proxy-stop.sh network-uplink-wait.sh qubes-early-vm-config.sh \
      qubes-iptables qubes-random-seed.sh qubes-sysinit.sh resize-rootfs-if-needed.sh setup-rwdev.sh setup-rw.sh; do
      patsh -f $out/lib/qubes/init/$name -s ${builtins.storeDir}
      substituteInPlace $out/lib/qubes/init/$name \
        --replace-quiet "/usr/lib/qubes" "$out/lib/qubes"
    done
    for name in network-manager-prepare-conf-dir qubes-fix-nm-conf.sh qubes-setup-dnat-to-ns show-hide-nm-applet.sh; do
      patsh -f $out/lib/qubes/$name -s ${builtins.storeDir}
      substituteInPlace $out/lib/qubes/$name \
        --replace-quiet "/usr/lib/qubes" "$out/lib/qubes"
    done

    rm $out/lib/systemd/system-preset/75-qubes-vm.preset
    rm -d $out/lib/systemd/system-preset
    rm $out/lib/systemd/resolved.conf.d/30_resolved-no-mdns-or-llmnr.conf
    rm -d $out/lib/systemd/resolved.conf.d

    # Too many dropins which I don't use and have no ide how to make them work.
    rm -rf $out/lib/systemd/user/{evolution-*,tracker-*}
    rm -d $out/lib/systemd/user

  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "LIBDIR=/lib"
    "USER_DROPIN_DIR=/lib/systemd/user"
    "PYTHON=${python3}/bin/python"
    "PYTHON_PREFIX_ARG=--prefix=."
  ];
}
