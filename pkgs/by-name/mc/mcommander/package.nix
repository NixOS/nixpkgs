# mcommander (mc6): fork of GNU Midnight Commander by blue-panels.
# Built from the upstream release tarball, which is already bootstrapped
# (has configure + mc-version.h).
# Flags and deps mirror the project's own packaging/arch/PKGBUILD.in.
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
  perl,
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
    # man2hlp (doc build) is a perl script
    perl
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

  meta = {
    description = "M-Commander: Midnight Commander fork with panel plugins, mcstruct and an embedded terminal";
    homepage = "https://github.com/blue-panels/mcommander";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lapo ];
    mainProgram = "mcommander";
    platforms = lib.platforms.linux;
  };
})
