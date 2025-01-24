{
  lib,
  fetchgit,
  fetchFromGitHub,
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
  systemd,
  stdenv,
  fetchpatch,
  versionCheckHook,
}:

let
  pname = "proxmox-backup-client";
  version = "3.3.2";

  proxmox-backup_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-backup.git";
    tag = "v${version}";
    name = "proxmox-backup";
    hash = "sha256-0piUftzuK9e8KbOe+bc3SXWa0DlnEgk5iNGWGn4fw7Y=";
  };

  proxmox_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox.git";
    rev = "df6b705f564ff145faa14770db6493bc5da8cab3";
    name = "proxmox";
    hash = "sha256-6fQVK+G5FMPy+29hScMkvQ+MQQryYs8f8oooq1YGXbg=";
  };

  proxmox-fuse_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox-fuse.git";
    rev = "6faec3a52fcdb0df3ca13fee2977683824d62d01"; # 0.1.7-1
    name = "proxmox-fuse";
    hash = "sha256-FwkZ5L7gJr9xZTQkdVHmOP8vnzf+To5Wz2SbIEzGUOY=";
  };

  proxmox-pxar_src = fetchgit {
    url = "git://git.proxmox.com/git/pxar.git";
    rev = "410f326a08ef6c08141af5c7431beb2e16f0c666"; # 0.12.1
    name = "pxar";
    hash = "sha256-USvtrWTbP3VUiy9MB9Ym6s4wXBNZ4Ooyg4MRDwRVOtU=";
  };

  proxmox-pathpatterns_src = fetchgit {
    url = "git://git.proxmox.com/git/pathpatterns.git";
    rev = "5f625aacbd6f81d97a1c6f5476fb38769d069f26"; # 0.3.0
    name = "pathpatterns";
    hash = "sha256-717XSlvQdvP0Q516fEx04rsrLCk3QI8frTD5NMmkSr4=";
  };

  # needs a patched version
  h2_src = fetchFromGitHub {
    name = "h2";
    owner = "hyperium";
    repo = "h2";
    rev = "v0.4.7";
    hash = "sha256-GcO4321Jqt1w7jbvQKd0GXIjptyz+tlN2SuxHoBJ/9k=";
  };

  aurPatchCommit = "6f83f58d54bc7186211d0cfa637c652b13e0dfee";
in

rustPlatform.buildRustPackage {
  inherit pname version;

  srcs = [
    proxmox-backup_src
    proxmox_src
    proxmox-fuse_src
    proxmox-pxar_src
    proxmox-pathpatterns_src
    h2_src
  ];

  sourceRoot = proxmox-backup_src.name;

  # These patches are essentially un-upstreamable, due to being "workarounds" related to the
  # project structure.
  cargoPatches = [
    # A lot of Rust crates `proxmox-backup-client` depends on are only available through git (or
    # Debian packages). This patch redirects all these dependencies to a local, relative path, which
    # works in combination with the other three repos being checked out.
    ./0001-cargo-re-route-dependencies-not-available-on-crates..patch
    # `make docs` assumes that the binaries are located under `target/{debug,release}`, but due
    # to how `buildRustPackage` works, they get put under `target/$RUSTC_TARGET/{debug,release}`.
    # This patch simply fixes that up.
    ./0002-docs-Add-target-path-fixup-variable.patch
    # Need to use a patched version of the `h2` crate (with a downgraded dependency, see also postPatch).
    # This overrides it in the Cargo.toml as needed.
    ./0003-cargo-use-local-patched-h2-dependency.patch
    # This patch prevents the generation of the man-pages for other components inside the repo,
    # which would require them too be built too. Thus avoid wasting resources and just skip them.
    (fetchpatch {
      name = "0002-docs-drop-all-but-client-man-pages.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-docs-drop-all-but-client-man-pages.patch?h=proxmox-backup-client&id=${aurPatchCommit}";
      hash = "sha256-AlIGfJZGaZl2NBVfuFxpDL6bgyvXA2Wcz7UWSrnQa24=";
    })
  ];

  postPatch = ''
    # need to downgrade the `http` crate for `h2`
    # see https://aur.archlinux.org/cgit/aur.git/tree/0003-cargo-downgrade-http-to-0.2.12.patch?h=proxmox-backup-client
    cp -r ../h2 .
    chmod u+w ./h2
    (cd h2 && sed -i 's/^http = "1"$/http = "0.2.12"/' Cargo.toml)

    cp ${./Cargo.lock} Cargo.lock
    rm .cargo/config.toml
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
    systemd.dev
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = with lib; {
    description = "Command line client for Proxmox Backup Server";
    homepage = "https://pbs.proxmox.com/docs/backup-client.html";
    changelog = "https://git.proxmox.com/?p=proxmox-backup.git;a=blob;f=debian/changelog;hb=${proxmox-backup_src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      cofob
      christoph-heiss
    ];
    platforms = platforms.linux;
    mainProgram = "proxmox-backup-client";
  };
}
