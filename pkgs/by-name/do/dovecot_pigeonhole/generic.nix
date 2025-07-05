{
  lib,
  stdenv,
  fetchurl,
  openssl,
  openldap,
}:
{
  url,
  version,
  hash,
  dovecot,
}:
stdenv.mkDerivation rec {
  pname = "dovecot-pigeonhole";
  inherit version;

  src = fetchurl {
    inherit url hash;
  };

  buildInputs =
    [
      dovecot
      openssl
    ]
    ++ lib.optionals (lib.versionAtLeast version "2.4") [
      openldap
    ];

  preConfigure = ''
    substituteInPlace src/managesieve/managesieve-settings.c --replace-fail \
      ".executable = \"managesieve\"" \
      ".executable = \"$out/libexec/dovecot/managesieve\""
    substituteInPlace src/managesieve-login/managesieve-login-settings.c --replace-fail \
      ".executable = \"managesieve-login\"" \
      ".executable = \"$out/libexec/dovecot/managesieve-login\""
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=${placeholder "out"}/lib/dovecot/modules"
    "--without-dovecot-install-dirs"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://pigeonhole.dovecot.org/";
    description = "Sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ globin ] ++ teams.helsinki-systems.members;
    platforms = platforms.unix;
  };
}
