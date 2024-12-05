{ lib, stdenvNoCC, fetchurl, makeWrapper, perl, installShellFiles }:

stdenvNoCC.mkDerivation rec {
  pname = "listadmin";
  version = "2.73";

  src = fetchurl {
    url = "mirror://sourceforge/project/listadmin/${version}/listadmin-${version}.tar.gz";
    sha256 = "00333d65ygdbm1hqr4yp2j8vh1cgh3hyfm7iy9y1alf0p0f6aqac";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ makeWrapper installShellFiles ];

  # There is a Makefile, but we don’t need it, and it prints errors
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    install -m 755 listadmin.pl $out/bin/listadmin
    installManPage listadmin.1

    wrapProgram $out/bin/listadmin \
      --prefix PERL5LIB : "${with perl.pkgs; makeFullPerlPath [
        TextReform NetINET6Glue LWPProtocolHttps
        ]}"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/listadmin --help 2> /dev/null
  '';

  meta = with lib; {
    description = "Command line mailman moderator queue manipulation";
    longDescription = ''
       listadmin is a command line tool to manipulate the queues of messages
       held for moderator approval by mailman. It is designed to keep user
       interaction to a minimum, in theory you could run it from cron to prune
       the queue. It can use the score from a header added by SpamAssassin to
       filter, or it can match specific senders, subjects, or reasons.
    '';
    homepage = "https://sourceforge.net/projects/listadmin/";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nomeata ];
    mainProgram = "listadmin";
  };
}
