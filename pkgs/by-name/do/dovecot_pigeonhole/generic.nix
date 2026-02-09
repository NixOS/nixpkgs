{
  version,
  url,
  hash,
  patches ? _: [ ],
}:
{
  lib,
  stdenv,
  fetchpatch,
  fetchzip,
  dovecot,
  openssl,
  withLDAP ? true,
  cyrus_sasl,
  openldap,
}:
let
  dovecotMajorMinor = lib.versions.majorMinor dovecot.version;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dovecot-pigeonhole";
  inherit version;

  src = fetchzip {
    url = url {
      inherit (finalAttrs) version;
      inherit dovecotMajorMinor;
    };
    inherit hash;
  };

  patches = patches fetchpatch;

  buildInputs = [
    dovecot
    openssl
  ]
  ++ lib.optionals withLDAP [
    cyrus_sasl
    openldap
  ];

  preConfigure = ''
    substituteInPlace src/managesieve/managesieve-settings.c --replace \
      ".executable = \"managesieve\"" \
      ".executable = \"$out/libexec/dovecot/managesieve\""
    substituteInPlace src/managesieve-login/managesieve-login-settings.c --replace \
      ".executable = \"managesieve-login\"" \
      ".executable = \"$out/libexec/dovecot/managesieve-login\""
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=${placeholder "out"}/lib/dovecot/modules"
    "--without-dovecot-install-dirs"
  ]
  ++ lib.optional withLDAP "--with-ldap";

  enableParallelBuilding = true;

  meta = {
    homepage = "https://pigeonhole.dovecot.org/";
    description = "Sieve plugin for the Dovecot IMAP server";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
      jappie3
      prince213
    ];
    platforms = lib.platforms.unix;
  };
})
