{
  stdenv,
  lib,
  perl,
  perlPackages,
  makeWrapper,
  coreutils,
  notmuch,
}:

stdenv.mkDerivation {
  pname = "notmuch-mutt";
  version = notmuch.version;

  outputs = [ "out" ];

  dontStrip = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
  ]
  ++ (with perlPackages; [
    FileRemove
    DigestSHA1
    Later
    MailBox
    MailMaildir
    MailTools
    StringShellQuote
    TermReadLineGnu
  ]);

  src = notmuch.src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    ${coreutils}/bin/install -Dm755 \
      ./contrib/notmuch-mutt/notmuch-mutt \
      $out/bin/notmuch-mutt

    wrapProgram $out/bin/notmuch-mutt \
      --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    description = "Mutt support for notmuch";
    mainProgram = "notmuch-mutt";
    homepage = "https://notmuchmail.org/";
    license = with licenses; gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
