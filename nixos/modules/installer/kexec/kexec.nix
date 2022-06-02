{ pkgs
, lib
, modulesPath
, config
, ...
}:
let
  image = pkgs.runCommand "image" { buildInputs = [ pkgs.nukeReferences ]; } ''
    mkdir $out
    cp ${config.system.build.kernel}/${config.system.boot.loader.kernelFile} $out/kernel
    cp ${config.system.build.netbootRamdisk}/initrd $out/initrd
    echo "init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}" > $out/cmdline
    nuke-refs $out/kernel
  '';
  kexec_tarball_self_extract_script = pkgs.writeTextFile {
    executable = true;
    name = "kexec-nixos";
    text = ''
      #!/bin/sh
      set -u
      ARCHIVE=`awk '/^__ARCHIVE_BELOW__/ { print NR + 1; exit 0; }' $0`
      tail -n+$ARCHIVE $0 | tar -xJ -C /
      /kexec_nixos
      exit 1
      __ARCHIVE_BELOW__
    '';
  };
in
{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  config = {
    system.build.kexec_script = pkgs.writeTextFile {
      executable = true;
      name = "kexec-nixos";
      text = ''
        #!${pkgs.stdenv.shell}
        export PATH=${pkgs.kexec-tools}/bin:${pkgs.cpio}/bin:$PATH
        set -x
        set -e
        cd $(mktemp -d)
        pwd
        mkdir initrd
        pushd initrd
        if [ -e /ssh_pubkey ]; then
          cat /ssh_pubkey >> authorized_keys
        fi
        find -type f | cpio -o -H newc | gzip -9 > ../extra.gz
        popd
        cat ${image}/initrd extra.gz > final.gz

        kexec -l ${image}/kernel --initrd=final.gz --append="init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}"
        sync
        echo "executing kernel, filesystems will be improperly umounted"
        kexec -e
      '';
    };

    system.build.kexec_tarball =
      lib.mkForce (pkgs.callPackage "${toString modulesPath}/../lib/make-system-tarball.nix" {
        storeContents = [
          { object = config.system.build.kexec_script; symlink = "/kexec_nixos"; }
        ];
        contents = [ ];
      });

    system.build.kexec_bundle = pkgs.runCommand "kexec_bundle" { } ''
      cat \
        ${kexec_tarball_self_extract_script} \
        ${config.system.build.kexec_tarball}/tarball/nixos-system-${config.system.build.kexec_tarball.system}.tar.xz \
        > $out
      chmod +x $out
    '';
    boot.loader.grub.enable = false;
    boot.kernelParams = [
      "console=ttyS0,115200" # allows certain forms of remote access, if the hardware is setup right
      "panic=30"
      "boot.panic_on_fail" # reboot the machine upon fatal boot issues
    ];
    systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  };
}
