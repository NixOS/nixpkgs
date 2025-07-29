{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  gtk-doc,
  docbook_xml_dtd_43,
  python3,
  gobject-introspection,
  glib,
  udev,
  kmod,
  parted,
  cryptsetup,
  lvm2,
  util-linux,
  libbytesize,
  libndctl,
  nss,
  volume_key,
  libxslt,
  docbook_xsl,
  gptfdisk,
  libyaml,
  autoconf-archive,
  thin-provisioning-tools,
  makeBinaryWrapper,
  e2fsprogs,
  libnvme,
  keyutils,
  libatasmart,
  json-glib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libblockdev";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    rev = finalAttrs.version;
    hash = "sha256-Q7610i+2PQi+Oza3c2SwPneljrb+1cuFA4K4DQTpt8A=";
  };

  patches = [
    # CVE-2025-6019: https://www.openwall.com/lists/oss-security/2025/06/17/5
    (fetchpatch {
      url = "https://github.com/storaged-project/libblockdev/commit/4e35eb93e4d2672686789b9705623cc4f9f85d02.patch";
      hash = "sha256-3pQxvbFX6jmT5LCaePoVfvPTNPoTPPhT0GcLaGkVVso=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "devdoc"
    "python"
  ];

  postPatch = ''
    patchShebangs scripts
    substituteInPlace src/python/gi/overrides/Makefile.am \
      --replace-fail ''\'''${exec_prefix}' '@PYTHON_EXEC_PREFIX@'
  '';

  configureFlags = [
    "--with-python_prefix=${placeholder "python"}"
  ];

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    docbook_xsl
    docbook_xml_dtd_43
    gobject-introspection
    gtk-doc
    libxslt
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    cryptsetup
    e2fsprogs
    glib
    gptfdisk
    json-glib
    keyutils
    kmod
    libatasmart
    libbytesize
    libndctl
    libnvme
    libyaml
    lvm2
    nss
    parted
    udev
    util-linux
    volume_key
  ];

  postInstall = ''
    wrapProgram $out/bin/lvm-cache-stats --prefix PATH : \
      ${lib.makeBinPath [ thin-provisioning-tools ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/storaged-project/libblockdev/raw/${finalAttrs.src.rev}/NEWS.rst";
    description = "Library for manipulating block devices";
    homepage = "http://storaged.org/libblockdev/";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Plus
    ]; # lgpl2Plus for the library, gpl2Plus for the utils
    maintainers = with lib.maintainers; [ johnazoidberg ];
    platforms = lib.platforms.linux;
  };
})
