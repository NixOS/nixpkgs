{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  perl,
  openssl,
  db,
  cyrus_sasl,
  zlib,
  perl538Packages,
  autoreconfHook,
  # Disabled by default as XOAUTH2 is an "OBSOLETE" SASL mechanism and this relies
  # on a package that isn't really maintained anymore:
  withCyrusSaslXoauth2 ? false,
  cyrus-sasl-xoauth2,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isync";
  version = "1.5.1";

  src = fetchgit {
    url = "https://git.code.sf.net/p/isync/isync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l0jL4CzAdFtQGekbywic1Kuihy3ZQi4ozhSEcbJI0t0=";
  };

  # Fixes "Fatal: buffer too small" error
  # see https://sourceforge.net/p/isync/mailman/isync-devel/thread/87fsevvebj.fsf%40steelpick.2x.cz/
  env.NIX_CFLAGS_COMPILE = "-DQPRINTF_BUFF=4000";

  autoreconfPhase = ''
    echo "${finalAttrs.version}" > VERSION
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
  ] ++ lib.optionals withCyrusSaslXoauth2 [ makeWrapper ];
  buildInputs = [
    perl538Packages.TimeDate
    openssl
    db
    cyrus_sasl
    zlib
  ];

  postInstall = lib.optionalString withCyrusSaslXoauth2 ''
    wrapProgram "$out/bin/mbsync" \
        --prefix SASL_PATH : "${
          lib.makeSearchPath "lib/sasl2" [
            cyrus-sasl-xoauth2
            cyrus_sasl.out
          ]
        }"
  '';

  meta = {
    homepage = "http://isync.sourceforge.net/";
    # https://sourceforge.net/projects/isync/
    changelog = "https://sourceforge.net/p/isync/isync/ci/v${finalAttrs.version}/tree/NEWS";
    description = "Free IMAP and MailDir mailbox synchronizer";
    longDescription = ''
      mbsync (formerly isync) is a command line application which synchronizes
      mailboxes. Currently Maildir and IMAP4 mailboxes are supported. New
      messages, message deletions and flag changes can be propagated both ways.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mbsync";
  };
})
