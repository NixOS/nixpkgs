{ isoFile
, productKey
, sshPublicKey
}:

let
  inherit (import <nixpkgs> {}) lib runCommand;

  bootstrapAfterLogin = runCommand "bootstrap.sh" {} ''
    cat > "$out" <<EOF
    mkdir -p ~/.ssh
    cat > ~/.ssh/authorized_keys <<PUBKEY
    $(cat "${sshPublicKey}")
    PUBKEY
    ssh-host-config -y -c 'binmode ntsec' -w dummy
    cygrunsrv -S sshd

    net use S: '\\192.168.0.2\nixstore'
    mkdir -p /nix/store
    mount -o bind /cygdrives/s /nix/store
    EOF
  '';

  packages = [ "openssh" ];

in {
  iso = import ../cygwin-iso {
    inherit packages;
    extraContents = lib.singleton {
      source = bootstrapAfterLogin;
      target = "bootstrap.sh";
    };
  };

  floppy = import ./unattended-image.nix {
    cygwinPackages = packages;
    inherit productKey;
  };
}
