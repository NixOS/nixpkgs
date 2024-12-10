{
  lib,
  fetchgit,
  rustPlatform,
  pkg-config,
  pkgconf,
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
  version = "3.2.2";

  proxmox-backup_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-backup.git";
    rev = "v${version}";
    name = "proxmox-backup";
    hash = "sha256-9rzUGaUoc87VkB4XJUwI0BjuvxdemE6fjTIR7VRp55Y=";
  };

  # Same revision as used in
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=proxmox-backup-client
  proxmox_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox.git";
    rev = "863d7603403405ccbf8e841b875bf3c9a7a76116";
    name = "proxmox";
    hash = "sha256-aSBT0TGhmM7QDux4gDY1k4HQhAMNWvxX+IVIsq6KeuM=";
  };

  proxmox-fuse_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-fuse.git";
    rev = "6faec3a52fcdb0df3ca13fee2977683824d62d01"; # 0.1.7-1
    name = "proxmox-fuse";
    hash = "sha256-FwkZ5L7gJr9xZTQkdVHmOP8vnzf+To5Wz2SbIEzGUOY=";
  };

  proxmox-pxar_src = fetchgit {
    url = "git://git.proxmox.com/git/pxar.git";
    rev = "675ecff32fbeff0973eaea016c4b8f3877015adb";
    name = "pxar";
    hash = "sha256-P5fblRCFq7NI1UkP/jkg38bamM1yuJYX+YhCKPgS15Y=";
  };

  proxmox-pathpatterns_src = fetchgit {
    url = "git://git.proxmox.com/git/pathpatterns.git";
    rev = "5f625aacbd6f81d97a1c6f5476fb38769d069f26"; # 0.3.0
    name = "pathpatterns";
    hash = "sha256-717XSlvQdvP0Q516fEx04rsrLCk3QI8frTD5NMmkSr4=";
  };

  aurPatchCommit = "12c04aa14ee09cb3dafcbe193da9d36a6809695d";
in

rustPlatform.buildRustPackage {
  inherit pname version;

  srcs = [
    proxmox-backup_src
    proxmox_src
    proxmox-fuse_src
    proxmox-pxar_src
    proxmox-pathpatterns_src
  ];

  sourceRoot = proxmox-backup_src.name;

  # These patches are essentially un-upstreamable, due to being "workarounds" related to the
  # project structure.
  cargoPatches = [
    # A lot of Rust crates `proxmox-backup-client` depends on are only available through git (or
    # Debian packages). This patch redirects all these dependencies to a local, relative path, which
    # works in combination with the other three repos being checked out.
    (fetchpatch {
      name = "0001-re-route-dependencies-not-available-on-crates.io-to-.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-re-route-dependencies-not-available-on-crates.io-to-.patch?h=proxmox-backup-client&id=${aurPatchCommit}";
      hash = "sha256-YOlC8A1FKIbNY9+q6n/gDV0efHx2i3kwsmIdZcYhf80=";
    })
    # This patch prevents the generation of the man-pages for other components inside the repo,
    # which would require them too be built too. Thus avoid wasting resources and just skip them.
    (fetchpatch {
      name = "0002-docs-drop-all-but-client-man-pages.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-docs-drop-all-but-client-man-pages.patch?h=proxmox-backup-client&id=${aurPatchCommit}";
      hash = "sha256-vUGDBx+g05ipL+boY9DaWDAMmstY1IDZs5nILbCIBLY=";
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
      RUSTC_TARGET=${stdenv.hostPlatform.config} \
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

  nativeBuildInputs = [
    git
    pkg-config
    pkgconf
    rustPlatform.bindgenHook
    installShellFiles
    sphinx
  ];
  buildInputs = [
    openssl
    fuse3
    libuuid
    acl
    libxcrypt
  ];

  passthru.tests.version = testers.testVersion {
    package = proxmox-backup-client;
    command = "${pname} version";
  };

  meta = with lib; {
    description = "The command line client for Proxmox Backup Server";
    homepage = "https://pbs.proxmox.com/docs/backup-client.html";
    changelog = "https://git.proxmox.com/?p=proxmox-backup.git;a=blob;f=debian/changelog;hb=refs/tags/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      cofob
      christoph-heiss
    ];
    platforms = platforms.linux;
    mainProgram = "proxmox-backup-client";
  };
}
