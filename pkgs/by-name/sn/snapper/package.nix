{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  docbook_xsl,
  libxslt,
  docbook_xml_dtd_45,
  acl,
  attr,
  boost,
  btrfs-progs,
  coreutils,
  dbus,
  diffutils,
  e2fsprogs,
  libxml2,
  lvm2,
  pam,
  util-linux,
  json_c,
  nixosTests,
  ncurses,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapper";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "snapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8rIjfulMuh4HzZv08bX7gveJAo2X2GvswmBD3Ziu0NM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    docbook_xsl
    libxslt
    docbook_xml_dtd_45
  ];
  buildInputs = [
    acl
    attr
    boost
    btrfs-progs
    dbus
    diffutils
    e2fsprogs
    libxml2
    lvm2
    pam
    util-linux
    json_c
    ncurses
    zlib
  ];

  # Hard-coded root paths, hard-coded root paths everywhere...
  postPatch = ''
    for file in {client/installation-helper,client/systemd-helper,data,scripts,zypp-plugin,scripts/completion}/Makefile.am; do
      substituteInPlace $file \
        --replace-warn '$(DESTDIR)/usr' "$out" \
        --replace-warn "DESTDIR" "out" \
        --replace-warn "/usr" "$out"
    done
  '';

  configureFlags = [
    "--disable-ext4" # requires patched kernel & e2fsprogs
    "DIFFBIN=${diffutils}/bin/diff"
    "RMBIN=${coreutils}/bin/rm"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    rm -r $out/etc/cron.*
    patchShebangs $out/lib/zypp/plugins/commit/*
    for file in \
      $out/lib/pam_snapper/* \
      $out/lib/systemd/system/* \
      $out/share/dbus-1/system-services/* \
    ; do
      substituteInPlace $file --replace-warn "/usr" "$out"
    done
  '';

  passthru.tests.snapper = nixosTests.snapper;

  meta = {
    description = "Tool for Linux filesystem snapshot management";
    homepage = "http://snapper.io";
    license = lib.licenses.gpl2Only;
    mainProgram = "snapper";
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
  };
})
