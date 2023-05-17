{
  lib, fetchgit, rustPlatform, pkg-config, openssl, fuse3, libuuid, acl,
  libxcrypt, git, installShellFiles, sphinx, stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "proxmox-backup-client";
  version = "2.4.1";

  srcs = [
    (fetchgit {
      url = "git://git.proxmox.com/git/proxmox-backup.git";
      rev = "v${version}";
      name = "proxmox-backup";
      hash = "sha256-DWzNRi675ZP9HGc/uPvnV/FBTJUNZ4K5RtU9NFRQCcA=";
    })
    (fetchgit {
      url = "git://git.proxmox.com/git/proxmox.git";
      rev = "5df815f660e4f3793e974eb8130224538350bb12";
      name = "proxmox";
      hash = "sha256-Vn1poqkIWcR2rNiAr+ENLNthgk3pMCivzXnUX9hvZBw=";
    })
    (fetchgit {
      url = "git://git.proxmox.com/git/proxmox-fuse.git";
      rev = "93099f76b6bbbc8a0bbaca9b459a1ce4dc5e0a79";
      name = "proxmox-fuse";
      hash = "sha256-3l0lAZVFQC0MYaqZvB+S+ihb1fTkEgs5i9q463+cbvQ=";
    })
    (fetchgit {
      url = "git://git.proxmox.com/git/pxar.git";
      rev = "6ad046f9f92b40413f59cc5f4c23d2bafdf141f2";
      name = "pxar";
      hash = "sha256-I9kk27oN9BDQpnLDWltjZMrh2yJitCpcD/XAhkmtJUg=";
    })
  ];

  sourceRoot = "proxmox-backup";

  cargoPatches = [
    ./0001-re-route-dependencies-not-available-on-crates.io-to-.patch
    ./0002-docs-drop-all-but-client-man-pages.patch
    ./0003-docs-Add-target-path-fixup-variable.patch
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    rm .cargo/config
  '';

  postBuild = ''
    make -C docs \
      DEB_VERSION=${version} DEB_VERSION_UPSTREAM=${version} \
      RUSTC_TARGET=${stdenv.targetPlatform.config} \
      BUILD_MODE=release \
      proxmox-backup-client.1 pxar.1
  '';

  postInstall = ''
    installManPage docs/output/man/proxmox-backup-client.1
    installShellCompletion --cmd proxmox-backup-client \
      --bash debian/proxmox-backup-client.bc \
      --zsh zsh-completions/_proxmox-backup-client

    installManPage docs/output/man/pxar.1
    installShellCompletion --cmd pxar \
      --bash debian/pxar.bc \
      --zsh zsh-completions/_pxar
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

  nativeBuildInputs = [ git pkg-config rustPlatform.bindgenHook installShellFiles sphinx ];
  buildInputs = [ openssl fuse3 libuuid acl libxcrypt ];

  meta = with lib; {
    description = "The command line client for Proxmox Backup Server";
    homepage = "https://pbs.proxmox.com/docs/backup-client.html";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ cofob christoph-heiss ];
    platforms = platforms.linux;
    mainProgram = pname;
  };
}
