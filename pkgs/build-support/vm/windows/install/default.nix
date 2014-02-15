{ isoFile
, productKey
}:

let
  inherit (import <nixpkgs> {}) lib stdenv runCommand openssh;

  bootstrapAfterLogin = runCommand "bootstrap.sh" {} ''
    cat > "$out" <<EOF
    mkdir -p ~/.ssh
    cat > ~/.ssh/authorized_keys <<PUBKEY
    $(cat "${cygwinSshKey}/key.pub")
    PUBKEY
    ssh-host-config -y -c 'binmode ntsec' -w dummy
    cygrunsrv -S sshd

    net use S: '\\192.168.0.2\nixstore'
    mkdir -p /nix/store
    mount -o bind /cygdrives/s /nix/store
    EOF
  '';

  cygwinSshKey = stdenv.mkDerivation {
    name = "snakeoil-ssh-cygwin";
    buildCommand = ''
      ensureDir "$out"
      ${openssh}/bin/ssh-keygen -t ecdsa -f "$out/key" -N ""
    '';
  };

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

  sshKey = "${cygwinSshKey}/key";
}
