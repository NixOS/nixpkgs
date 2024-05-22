{
  lib,
  stdenv,
  fetchFromGitHub,
  avahi,
  darwin,
  dbus,
  gnutls,
  libressl,
  openssl,
  pkg-config,
  poppler_utils,
  zlib,
  nix-update-script,
  enableDbus ? stdenv.isLinux,
  enablePopplerUtils ? stdenv.isLinux,
  sslBackend ? "libressl", # acceptable values: libressl openssl gnutls none
}:
assert lib.assertMsg (builtins.elem sslBackend [
  "gnutls"
  "libressl"
  "openssl"
  "none"
]) "sslBackend must be one of 'gnutls', 'libressl', 'openssl', or 'none'";
let
  dbusOnDarwinWarning = lib.warnIf (
    enableDbus && stdenv.isDarwin
  ) "DBus is not supported on Darwin. Disabling.";

  useLibressl = sslBackend == "libressl";
  useOpenssl = sslBackend == "openssl";
  useGnutls = sslBackend == "gnutls";

  usePopplerUtils = enablePopplerUtils;
  useCoregraphics = !enablePopplerUtils && stdenv.isDarwin;

  useAvahi = !stdenv.isDarwin;
  useMdnsresponder = stdenv.isDarwin;

  useDbus = enableDbus && !stdenv.isDarwin;
in
stdenv.mkDerivation {
  pname = "libcups3";
  version = "0-unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libcups";
    rev = "4d3a161e04049cbedc14049f12f281c7bf6134a8";
    fetchSubmodules = true;
    hash = "sha256-jq0Zv7+WiwWocgooPGyh7BdZfbnTPJpe9B6sluaosbk=";
  };

  strictDeps = false; # Required to find poppler-utils
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ zlib ]
    ++ lib.optional useDbus dbus
    ++ lib.optional useLibressl libressl
    ++ lib.optional useOpenssl openssl
    ++ lib.optional useGnutls gnutls
    ++ lib.optional usePopplerUtils poppler_utils
    ++ lib.optional useAvahi avahi
    ++ lib.optionals useMdnsresponder (
      with darwin;
      [
        configd
        apple_sdk.frameworks.ApplicationServices
      ]
    );

  configurePlatforms = lib.optionals stdenv.isLinux [
    "build"
    "host"
  ];
  configureFlags =
    [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
    ]
    ++ lib.optional useAvahi "--with-dnssd=avahi"
    ++ lib.optional useMdnsresponder "--with-dnssd=mdnsresponder"
    ++ lib.optional useLibressl "--with-tls=libressl"
    ++ lib.optional useOpenssl "--with-tls=openssl"
    ++ lib.optional useGnutls "--with-tls=gnutls"
    ++ lib.optional usePopplerUtils "--with-pdfrip=pdftoppm"
    ++ lib.optional useCoregraphics "--with-pdfrip=coregraphics"
    ++ lib.optional (!useDbus) "--disable-dbus";

  postPatch = ''
    # Disable the examples build
    substituteInPlace Makefile \
      --replace " examples" ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The Common UNIX Printing System (CUPS) library";
    homepage = "https://openprinting.github.io/cups/cups3.html";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
