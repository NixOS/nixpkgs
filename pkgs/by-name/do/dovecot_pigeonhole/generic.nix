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
  python3,
  withLDAP ? true,
  cyrus_sasl,
  openldap,
}:
let
  dovecotMajorMinor = lib.versions.majorMinor dovecot.version;
  isCurrent = lib.strings.versionAtLeast version "2.4";
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

  postPatch = lib.optionalString isCurrent ''
    patchShebangs src/plugins/settings/settings-get.pl
  '';

  nativeBuildInputs = lib.optional isCurrent perl;

  buildInputs = [
    dovecot
    openssl
  ]
  ++ lib.optional (isCurrent && stdenv.hostPlatform.isDarwin) libstemmer
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

  preBuild = lib.optionalString (!isCurrent && stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -undefined dynamic_lookup"
  '';

  # https://github.com/dovecot/pigeonhole/blob/2.4.3/src/plugins/settings/Makefile.am#L43-L44
  makeFlags = lib.optionals isCurrent [
    "PYTHON=${python3.pythonOnBuildForHost.interpreter}"
    "SETTINGS_HISTORY_PY=${dovecot}/libexec/dovecot/settings-history.py"
  ];

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
