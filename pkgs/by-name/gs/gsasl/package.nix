{
  fetchurl,
  lib,
  stdenv,
  libidn,
  libkrb5,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsasl";
  version = "2.2.4";

  src = fetchurl {
    url = "mirror://gnu/gsasl/gsasl-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-0yvhXv06BMsZsjL3Ib3KAsxq16tBXffXn7LdLA2j4L4=";
  };

  buildInputs = [
    libidn
    libkrb5
  ];

  configureFlags = [ "--with-gssapi-impl=mit" ];

  preCheck = ''
    export LOCALDOMAIN="dummydomain"
  '';
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "GNU SASL, Simple Authentication and Security Layer library";
    mainProgram = "gsasl";

    longDescription = ''
      GNU SASL is a library that implements the IETF Simple
      Authentication and Security Layer (SASL) framework and
      some SASL mechanisms. SASL is used in network servers
      (e.g. IMAP, SMTP, etc.) to authenticate peers.
    '';

    homepage = "https://www.gnu.org/software/gsasl/";
    license = lib.licenses.gpl3Plus;

    maintainers = with lib.maintainers; [ shlevy ];
    pkgConfigModules = [ "libgsasl" ];
    platforms = lib.platforms.all;
  };
})
