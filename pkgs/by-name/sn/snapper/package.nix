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

stdenv.mkDerivation rec {
  pname = "snapper";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "snapper";
    rev = "v${version}";
    sha256 = "sha256-Hh5etDx7nLBYC6VLeZS4F52w2VpaA4aZRvGUQ0QGBJc=";
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

  passthru.tests.snapper = nixosTests.snapper;

  postPatch = ''
    # Hard-coded root paths, hard-coded root paths everywhere...
    for file in {client,client/installation-helper,client/systemd-helper,data,pam,scripts,zypp-plugin}/Makefile.am; do
      substituteInPlace $file \
        --replace '$(DESTDIR)/usr' "$out" \
        --replace "DESTDIR" "out" \
        --replace "/usr" "$out"
    done
    substituteInPlace pam/Makefile.am \
      --replace '/`basename $(libdir)`' "$out/lib"
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
      substituteInPlace $file --replace "/usr" "$out"
    done
  '';

  meta = {
    description = "Tool for Linux filesystem snapshot management";
    homepage = "http://snapper.io";
    license = lib.licenses.gpl2Only;
    mainProgram = "snapper";
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
  };
}
