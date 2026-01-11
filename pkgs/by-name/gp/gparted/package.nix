{
  lib,
  stdenv,
  fetchurl,
  gettext,
  coreutils,
  gnused,
  adwaita-icon-theme,
  gnugrep,
  parted,
  glib,
  libuuid,
  pkg-config,
  gtkmm3,
  libxml2,
  gpart,
  hdparm,
  procps,
  polkit,
  wrapGAppsHook3,
  replaceVars,
  mtools,
  xhost,
  dosfstools,
  e2fsprogs,
  util-linuxMinimal,
  withAllTools ? false,
  bcachefs-tools,
  btrfs-progs,
  exfatprogs,
  f2fs-tools,
  hfsprogs,
  jfsutils,
  cryptsetup,
  lvm2,
  nilfs-utils,
  ntfs3g,
  udftools,
  xfsprogs,
  xfsdump,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gparted";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/gparted-${finalAttrs.version}.tar.gz";
    hash = "sha256-hK47mXPkQ6IXXweqDcKs7q2xUB4PiVPOyDsOwzR7fVI=";
  };

  # Tries to run `pkexec --version` to get version.
  # however the binary won't be suid so it returns
  # an error preventing the program from detection
  patches = [
    (replaceVars ./polkit.patch {
      polkit_version = polkit.version;
    })
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-doc"
    "--enable-xhost-root"
  ];

  buildInputs = [
    parted
    glib
    libuuid
    gtkmm3
    libxml2
    polkit.bin
    adwaita-icon-theme
  ];
  nativeBuildInputs = [
    gettext
    pkg-config
    wrapGAppsHook3
  ];

  runtimeDeps = [
    dosfstools
    e2fsprogs
    util-linuxMinimal
  ]
  ++ lib.optionals withAllTools [
    bcachefs-tools
    btrfs-progs
    exfatprogs
    f2fs-tools
    hfsprogs
    jfsutils
    cryptsetup
    lvm2
    nilfs-utils
    ntfs3g
    udftools
    xfsprogs
    xfsdump
  ];

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix PATH : "${
         lib.makeBinPath (
           [
             gpart
             hdparm
             procps
             coreutils
             gnused
             gnugrep
             mtools
             xhost
           ]
           ++ finalAttrs.runtimeDeps
         )
       }"
    )
  '';

  # Doesn't get installed automatically if PREFIX != /usr
  postInstall = ''
    install -D -m0644 org.gnome.gparted.policy \
      $out/share/polkit-1/actions/org.gnome.gparted.policy
  '';

  meta = {
    description = "Graphical disk partitioning tool";
    longDescription = ''
      GNOME Partition Editor for creating, reorganizing, and deleting disk
      partitions. GParted enables you to change the partition organization
      while preserving the partition contents.
    '';
    homepage = "https://gparted.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gparted";
  };
})
