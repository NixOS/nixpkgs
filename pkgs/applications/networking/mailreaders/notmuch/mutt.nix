{ stdenv, lib, perl, perlPackages, makeWrapper, coreutils, notmuch }:

stdenv.mkDerivation rec {
  name = "notmuch-mutt-${version}";
  version = notmuch.version;

  outputs = [ "out" ];

  dontStrip = true;

  buildInputs = [
    perl
    makeWrapper
  ] ++ (with perlPackages; [
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

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    ${coreutils}/bin/install -Dm755 \
      ./contrib/notmuch-mutt/notmuch-mutt \
      $out/bin/notmuch-mutt

    wrapProgram $out/bin/notmuch-mutt \
      --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    inherit version;
    description = "Mutt support for notmuch";
    homepage    = http://notmuchmua.org/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
