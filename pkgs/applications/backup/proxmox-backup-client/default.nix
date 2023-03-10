{ lib, fetchgit, rustPlatform, pkg-config, openssl, fuse3, libuuid, acl, libxcrypt }:

rustPlatform.buildRustPackage rec {
  pname = "proxmox-backup-client";
  version = "2.2.1";

  srcs = [
    (fetchgit {
      url = "git://git.proxmox.com/git/proxmox-backup.git";
      rev = "v${version}";
      name = pname;
      hash = "sha256-uOKQe/BzO69f/ggEPoZQ2Rn3quytQrUeH7be19QV3KI=";
    })
    (fetchgit {
      url = "git://git.proxmox.com/git/proxmox.git";
      rev = "43b4440ef015d846161657490b18cf6ac7600fc4";
      name = "proxmox";
      hash = "sha256-05Z+IRRIioFGn+iAYG04DyNsgw9gQrJ6qAArpCwoIb0=";
    })
    (fetchgit {
      url = "git://git.proxmox.com/git/proxmox-fuse.git";
      rev = "d162ef9039878b871e2aa11b7d9a373ae512e2d1";
      name = "proxmox-fuse";
      hash = "sha256-w33ViWpBkCkMAhZVXiOdqnGOn/tddNRgzn71WioTnBU=";
    })
    (fetchgit {
      url = "git://git.proxmox.com/git/pxar.git";
      rev = "6f3f889e98c5f4e60c3b2c6bce73bd506b548c21";
      name = "pxar";
      hash = "sha256-GtNq6+O1xnxuR7b4TTWLFxcsejRyadSlk85H8C+yUGA=";
    })
  ];

  sourceRoot = pname;

  cargoPatches = [
    ./re-route-dependencies.patch
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    rm .cargo/config
  '';

  cargoLock = {
    lockFileContents = builtins.readFile ./Cargo.lock;
  };

  cargoBuildFlags = [
    "--package=proxmox-backup-client"
    "--bin=proxmox-backup-client"
    "--bin=dump-catalog-shell-cli"

    "--package=pxar-bin"
    "--bin=pxar"
  ];

  doCheck = false;

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ openssl fuse3 libuuid acl libxcrypt ];

  meta = with lib; {
    description = "The command line client for Proxmox Backup Server";
    homepage = "https://pbs.proxmox.com/docs/backup-client.html";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ cofob ];
    platforms = platforms.linux;
  };
}
