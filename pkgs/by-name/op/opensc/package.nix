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
  darwin,
  buildPackages,
  nix-update-script,
  withApplePCSC ? stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation rec {
  pname = "opensc";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "sha256-EIQ9YpIGwckg/JjpK0S2ZYdFf/0YC4KaWcLXRNRMuzA=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs =
    [
      zlib
      readline
      openssl
      libassuan
      libXt
      libxslt
      libiconv
      docbook_xml_dtd_412
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Carbon
    ++ (if withApplePCSC then [ darwin.apple_sdk.frameworks.PCSC ] else [ pcsclite ]);

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
    "--with-pcsc-provider=${
      if withApplePCSC then
        "${darwin.apple_sdk.frameworks.PCSC}/Library/Frameworks/PCSC.framework/PCSC"
      else
        "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
    }"
    (lib.optionalString (
      stdenv.hostPlatform != stdenv.buildPlatform
    ) "XSLTPROC=${buildPackages.libxslt}/bin/xsltproc")
  ];

  PCSC_CFLAGS = lib.concatStringsSep " " (
    lib.optionals withApplePCSC [
      "-I${darwin.apple_sdk.frameworks.PCSC}/Library/Frameworks/PCSC.framework/Headers"
      "-I${lib.getDev pcsclite}/include/PCSC"
    ]
  );

  installFlags = [
    "sysconfdir=$(out)/etc"
    "completiondir=$(out)/etc"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Set of libraries and utilities to access smart cards";
    homepage = "https://github.com/OpenSC/OpenSC/wiki";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.michaeladler ];
  };
}
