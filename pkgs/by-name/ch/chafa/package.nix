{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  autoconf,
  automake,
  libtool,
  pkg-config,
  which,
  libavif,
  libjxl,
  librsvg,
  libxslt,
  libxml2,
  docbook_xml_dtd_412,
  docbook_xsl,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.16.1";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    tag = finalAttrs.version;
    hash = "sha256-O57L/VR3M1dTMg+UES6NGh4hU2D7/e9boTMNo6sR/ws=";
  };

  outputs = [
    "bin"
    "dev"
    "man"
    "out"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    which
    libxslt
    libxml2
    docbook_xml_dtd_412
    docbook_xsl
    installShellFiles
  ];

  buildInputs = [
    glib
    libavif
    libjxl
    librsvg
  ];

  patches = [ ./xmlcatalog_patch.patch ];

  preConfigure = ''
    substituteInPlace ./autogen.sh --replace pkg-config '$PKG_CONFIG'
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--enable-man"
    "--with-xml-catalog=${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml"
  ];

  postInstall = ''
    installShellCompletion --cmd chafa \
      --fish tools/completions/fish-completion.fish \
      --zsh tools/completions/zsh-completion.zsh
  '';

  meta = {
    description = "Terminal graphics for the 21st century";
    homepage = "https://hpjansson.org/chafa/";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      mog
      prince213
    ];
    mainProgram = "chafa";
  };
})
