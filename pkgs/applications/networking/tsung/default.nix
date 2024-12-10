{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  erlang,
  python3,
  python3Packages,
  perlPackages,
  gnuplot,
}:

stdenv.mkDerivation rec {
  pname = "tsung";
  version = "1.8.0";

  src = fetchurl {
    url = "http://tsung.erlang-projects.org/dist/tsung-${version}.tar.gz";
    hash = "sha256-kehkMCYBfj0AiKZxD7EcT2F0d+gm6+TF/lhqpjFH/JI=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    erlang
    gnuplot
    perlPackages.perl
    perlPackages.TemplateToolkit
    python3
    python3Packages.matplotlib
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

  meta = with lib; {
    homepage = "http://tsung.erlang-projects.org/";
    changelog = "https://github.com/processone/tsung/blob/v${version}/CHANGELOG.md";
    description = "A high-performance benchmark framework for various protocols including HTTP, XMPP, LDAP, etc";
    longDescription = ''
      Tsung is a distributed load testing tool. It is protocol-independent and
      can currently be used to stress HTTP, WebDAV, SOAP, PostgreSQL, MySQL,
      AMQP, MQTT, LDAP and Jabber/XMPP servers.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ uskudnik ];
    platforms = platforms.unix;
  };
}
