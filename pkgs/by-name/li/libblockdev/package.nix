{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libblockdev";
    tag = finalAttrs.version;
    hash = "sha256-KvcGvMsASgEKTerhh/lSPjQoXYDMBvbaPSdc6f5p7wc=";
  };

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

  strictDeps = true;

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
    changelog = "https://github.com/storaged-project/libblockdev/raw/${finalAttrs.src.tag}/NEWS.rst";
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
