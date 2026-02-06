{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  zlib,
  readline,
  openssl,
  libiconv,
  pcsclite,
  libassuan,
  libXt,
  docbook_xsl,
  libxslt,
  docbook_xml_dtd_412,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensc";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    tag = finalAttrs.version;
    hash = "sha256-H5df+x15fz28IlL/G9zPBxbNBzc+BlDmmgNZVEYQgac=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libxslt # xsltproc
  ];
  buildInputs = [
    zlib
    readline
    openssl
    libassuan
    libXt
    libiconv
    docbook_xml_dtd_412
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) pcsclite;

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  configureFlags = [
    "--enable-zlib"
    "--enable-readline"
    "--enable-openssl"
    "--enable-pcsc"
    "--enable-sm"
    "--enable-man"
    "--enable-doc"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-xsl-stylesheetsdir=${docbook_xsl}/xml/xsl/docbook"
  ]
  ++
    lib.optional (!stdenv.hostPlatform.isDarwin)
      "--with-pcsc-provider=${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}";

  installFlags = [
    "sysconfdir=$(out)/etc"
    "completiondir=$(out)/etc"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Set of libraries and utilities to access smart cards";
    homepage = "https://github.com/OpenSC/OpenSC/wiki";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.michaeladler ];
  };
})
