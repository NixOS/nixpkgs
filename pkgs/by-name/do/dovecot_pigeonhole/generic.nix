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
  libstemmer,
  perl,
  withLDAP ? true,
  cyrus_sasl,
  openldap,
}:
let
  dovecotMajorMinor = lib.versions.majorMinor dovecot.version;
  isCurrentOnDarwin = lib.strings.versionAtLeast version "2.4" && stdenv.hostPlatform.isDarwin;
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

  patches = patches fetchpatch ++ lib.optional isCurrentOnDarwin ./max_lookup_size.patch;

  postPatch = lib.optionalString isCurrentOnDarwin ''
    patchShebangs src/plugins/settings/settings-get.pl
  '';

  nativeBuildInputs = lib.optional isCurrentOnDarwin perl;

  buildInputs = [
    dovecot
    openssl
  ]
  ++ lib.optional isCurrentOnDarwin libstemmer
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

  preBuild = lib.optionalString (lib.strings.versionOlder version "2.4" && stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -undefined dynamic_lookup"
  '';

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
