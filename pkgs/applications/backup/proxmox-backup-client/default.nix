{ lib,
  fetchgit,
  rustPlatform,
  pkg-config,
  openssl,
  fuse3,
  libuuid,
  acl,
  libxcrypt,
  git,
  installShellFiles,
  sphinx,
  stdenv,
  fetchpatch,
  testers,
  proxmox-backup-client,
}:

let
  pname = "proxmox-backup-client";
  version = "3.0.1";

  proxmox-backup_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-backup.git";
    rev = "v${version}";
    name = "proxmox-backup";
    hash = "sha256-a6dPBZBBh//iANXoPmOdgxYO0qNszOYI3QtrjQr4Cxc=";
  };

  proxmox_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox.git";
    rev = "2a070da0651677411a245f1714895235b1caf584";
    name = "proxmox";
    hash = "sha256-WH6oW2MB2yN1Y2zqOuXewI9jHqev/xLcJtb7D1J4aUE=";
  };

  proxmox-fuse_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-fuse.git";
    rev = "93099f76b6bbbc8a0bbaca9b459a1ce4dc5e0a79";
    name = "proxmox-fuse";
    hash = "sha256-3l0lAZVFQC0MYaqZvB+S+ihb1fTkEgs5i9q463+cbvQ=";
  };

  proxmox-pxar_src = fetchgit {
    url = "git://git.proxmox.com/git/pxar.git";
    rev = "6ad046f9f92b40413f59cc5f4c23d2bafdf141f2";
    name = "pxar";
    hash = "sha256-I9kk27oN9BDQpnLDWltjZMrh2yJitCpcD/XAhkmtJUg=";
  };
in

rustPlatform.buildRustPackage {
  inherit pname version;

  srcs = [ proxmox-backup_src proxmox_src proxmox-fuse_src proxmox-pxar_src ];

  sourceRoot = proxmox-backup_src.name;

  # These patches are essentially un-upstreamable, due to being "workarounds" related to the
  # project structure.
  cargoPatches = [
    # A lot of Rust crates `proxmox-backup-client` depends on are only available through git (or
    # Debian packages). This patch redirects all these dependencies to a local, relative path, which
    # works in combination with the other three repos being checked out.
    (fetchpatch {
      name = "0001-re-route-dependencies-not-available-on-crates.io-to-.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-re-route-dependencies-not-available-on-crates.io-to-.patch?h=proxmox-backup-client&id=83a1f4dfcb04bd181b11954b1d9f5ddfcb72b3d0";
      hash = "sha256-2YZtjbpYSbRk6rmpjKJeIO+V0YN5PrKsISONXMj4RG0=";
    })
    # This patch prevents the generation of the man-pages for other components inside the repo,
    # which would require them too be built too. Thus avoid wasting resources and just skip them.
    (fetchpatch {
      name = "0002-docs-drop-all-but-client-man-pages.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-docs-drop-all-but-client-man-pages.patch?h=proxmox-backup-client&id=83a1f4dfcb04bd181b11954b1d9f5ddfcb72b3d0";
      hash = "sha256-oJKQs4SwJvX5Zd0/l/vVr66aPO7Y4AC8byJHg9t1IhY=";
    })
    # `make docs` assumes that the binaries are located under `target/{debug,release}`, but due
    # to how `buildRustPackage` works, they get put under `target/$RUSTC_TARGET/{debug,release}`.
    # This patch simply fixes that up.
    ./0001-docs-Add-target-path-fixup-variable.patch
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

  passthru.tests.version = testers.testVersion {
    package = proxmox-backup-client;
    command = "${pname} version";
  };

  meta = with lib; {
    description = "The command line client for Proxmox Backup Server";
    homepage = "https://pbs.proxmox.com/docs/backup-client.html";
    changelog = "https://git.proxmox.com/?p=proxmox-backup.git;a=blob;f=debian/changelog;hb=refs/tags/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ cofob christoph-heiss ];
    platforms = platforms.linux;
    mainProgram = pname;
  };
}
