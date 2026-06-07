{
  lib,
  fetchgit,
  rustPlatform,
  pkgconf,
  openssl,
  fuse3,
  acl,
  installShellFiles,
  sphinx,
  stdenv,
  versionCheckHook,
}:

let
  pname = "proxmox-backup-client";
  version = "4.2.0";

  proxmox-backup_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-backup.git";
    rev = "035c449897fafc228c8bbf3a5b5ba38564478ac7";
    name = "proxmox-backup";
    hash = "sha256-tfZXmMWQrP0MiBC1uuSenGaghqHi4ljky6T2KtLcjhk=";
  };

  proxmox_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox.git";
    rev = "22c4d5ecbfce6eb2fd566181e0b7d23ac2df4f0c";
    name = "proxmox";
    hash = "sha256-rYaLx6Lorry+NkEmc6/xARMY6ZgdnIaCLJqRA0Mnf8o=";
  };

  proxmox-fuse_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-fuse.git";
    rev = "258788a3d66f7a77040a480170fff9890d4939aa"; # 3.0.0
    name = "proxmox-fuse";
    hash = "sha256-deEPxhg2uyswBYjgYrXcAEBByJ/4ptX7I9y0R3AAFA0=";
  };

  proxmox-pxar_src = fetchgit {
    url = "git://git.proxmox.com/git/pxar.git";
    rev = "091a8a382d0d6fc71025351fb35c51b1f3b0074d"; # 1.0.1
    name = "pxar";
    hash = "sha256-9SFlrz6nuVby6iQ2ELVaioZu2pcs90tSuyzLCWJlcrA=";
  };

  proxmox-pathpatterns_src = fetchgit {
    url = "git://git.proxmox.com/git/pathpatterns.git";
    rev = "42e5e96e30297da878a4d4b3a7fa52b65c1be0ab"; # 1.0.0
    name = "pathpatterns";
    hash = "sha256-U8EhTg/2iuArQvUNGNYrgVYn1T/jnxxqSKJxfsCMAjs=";
  };
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
  # project structure and upstream/Debian-specific packaging.
  cargoPatches = [
    # A lot of Rust crates `proxmox-backup-client` depends on are only available through git (or
    # Debian packages). This patch redirects all these dependencies to a local, relative path, which
    # works in combination with the other three repos being checked out.
    ./0001-cargo-re-route-dependencies-not-available-on-crates..patch
    # This patch prevents the generation of the man-pages for other components inside the repo,
    # which would require them too be built too. Thus avoid wasting resources and just skip them.
    ./0002-docs-drop-all-but-client-man-pages.patch
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    rm .cargo/config.toml

    # avoid some unnecessary dependencies, stemming from greedy linkage by rustc
    # see also upstream Makefile for similar workaround
    mkdir -p .dep-stubs
    echo '!<arch>' >.dep-stubs/libsystemd.a
    echo '!<arch>' >.dep-stubs/libuuid.a
    echo '!<arch>' >.dep-stubs/libcrypt.a
  '';

  postBuild = ''
    make -C docs \
      DEB_VERSION=${version} DEB_VERSION_UPSTREAM=${version} \
      DEB_HOST_RUST_TYPE=${stdenv.targetPlatform.rust.rustcTarget} \
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

  env = {
    RUSTFLAGS = toString [ "-L.dep-stubs" ];
    # pbs-buildcfg requires this set, would be the git commit id
    REPOID = "";
  };

  doCheck = false;

  nativeBuildInputs = [
    pkgconf
    rustPlatform.bindgenHook
    installShellFiles
    sphinx
  ];

  buildInputs = [
    openssl
    fuse3
    acl
  ];

  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Command line client for Proxmox Backup Server";
    homepage = "https://pbs.proxmox.com/docs/backup-client.html";
    changelog = "https://git.proxmox.com/?p=proxmox-backup.git;a=blob;f=debian/changelog;hb=${proxmox-backup_src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      cofob
      christoph-heiss
    ];
    platforms = lib.platforms.linux;
    mainProgram = "proxmox-backup-client";
  };
}
