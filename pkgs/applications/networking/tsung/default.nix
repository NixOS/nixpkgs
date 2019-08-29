{ fetchurl, stdenv, lib, makeWrapper,
  erlang,
  python2, python2Packages,
  perlPackages,
  gnuplot }:

stdenv.mkDerivation rec {
  name = "tsung-${version}";
  version = "1.7.0";
  src = fetchurl {
    url = "http://tsung.erlang-projects.org/dist/tsung-${version}.tar.gz";
    sha256 = "6394445860ef34faedf8c46da95a3cb206bc17301145bc920151107ffa2ce52a";
  };

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [
    erlang
    gnuplot
    perlPackages.perl
    perlPackages.TemplateToolkit
    python2
    python2Packages.matplotlib
  ];


  postFixup = ''
    # Make tsung_stats.pl accessible
    # Leaving .pl at the end since all of tsung documentation is refering to it
    # as tsung_stats.pl
    ln -s $out/lib/tsung/bin/tsung_stats.pl $out/bin/tsung_stats.pl

    # Add Template Toolkit and gnuplot to tsung_stats.pl
    wrapProgram $out/bin/tsung_stats.pl \
        --prefix PATH : ${lib.makeBinPath [ gnuplot ]} \
        --set PERL5LIB "${perlPackages.makePerlPath [ perlPackages.TemplateToolkit ]}"
  '';

  meta = with stdenv.lib; {
    homepage = "http://tsung.erlang-projects.org/";
    description = "A high-performance benchmark framework for various protocols including HTTP, XMPP, LDAP, etc.";
    longDescription = ''
      Tsung is a distributed load testing tool. It is protocol-independent and
      can currently be used to stress HTTP, WebDAV, SOAP, PostgreSQL, MySQL,
      AMQP, MQTT, LDAP and Jabber/XMPP servers.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.uskudnik ];
    platforms = platforms.unix;
  };
}
