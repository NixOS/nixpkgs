# mcommander (mc6): fork of GNU Midnight Commander by blue-panels.
# Built from the upstream release tarball, which is already bootstrapped
# (has configure + mc-version.h).
# Flags and deps mirror the project's own Arch packaging (see
# `packaging/arch/PKGBUILD.in` in the upstream repository).
{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  glib,
  slang,
  gpm,
  e2fsprogs,
  file,
  libssh2,
  curl,
  samba,
  libarchive,
  mongoc,
  sqlite,
  lua5_4,
  coreutils,
  perl,

  # updater only
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcommander";
  version = "6.1.0";

  src = fetchurl {
    url = "https://github.com/blue-panels/mcommander/releases/download/v${finalAttrs.version}/mcommander-${finalAttrs.version}.tar.gz";
    hash = "sha256-MvozvoFvm7QHBQaK57Rowq1kDerY2jeKh4ZWVi1Z/Yg=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    glib
    slang
    gpm
    e2fsprogs
    file
    libssh2
    curl
    samba
    libarchive
    mongoc
    sqlite
    lua5_4
  ];

  configureFlags = [
    "--with-screen=slang"
    "--with-panel-plugins-dir=${placeholder "out"}/lib/mcommander/panel-plugins"
    "--with-editor-plugins-dir=${placeholder "out"}/lib/mcommander/editor-plugins"
    # perl used by the extfs helpers at run time:
    "PERL=${perl}/bin/perl"
    "--enable-mcterm=yes"
    "--enable-lua-plugin=yes"
    "--enable-mctree-magic=yes"
    "--enable-panel-plugin-samba=yes"
    "--enable-panel-plugin-ftp=yes"
    "--enable-panel-plugin-arcmc=yes"
    "--enable-panel-plugin-s3=yes"
    "--enable-panel-plugin-mongo=yes"
    "--enable-panel-plugin-sqlite=yes"
    "--enable-panel-plugin-shell-link=yes"
    "--enable-shell-ssh2=yes"
    "--enable-vfs-sftp=yes"
    # configure arguments have a bunch of build-only dependencies.
    # Avoid their retention in the final closure.
    "--disable-configure-args"
  ];

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace src/filemanager/ext.c \
      --replace-fail /bin/rm ${coreutils}/bin/rm
  '';

  passthru.updateScript = writeScript "update-mcommander" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre2 common-updater-scripts

    set -eu -o pipefail

    # Expect the JSON of the latest GitHub release ("tag_name": "v6.1.0").
    new_version="$(curl -s https://api.github.com/repos/blue-panels/mcommander/releases/latest | pcre2grep -o1 '"tag_name": *"v((([0-9]+)(\.[0-9]+)*))')"
    update-source-version mcommander "$new_version"
  '';

  meta = {
    description = "M-Commander: Midnight Commander fork with panel plugins, mcstruct and an embedded terminal";
    homepage = "https://github.com/blue-panels/mcommander";
    downloadPage = "https://github.com/blue-panels/mcommander/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lapo ];
    mainProgram = "mcommander";
    platforms = lib.platforms.linux;
  };
})
