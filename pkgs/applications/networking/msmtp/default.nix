{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig
, openssl, netcat-gnu, gnutls, gsasl, libidn, Security
, systemd ? null }:

let
  tester = "n"; # {x| |p|P|n|s}
  journal = if stdenv.isLinux then "y" else "n";

in stdenv.mkDerivation rec {
  name = "msmtp-${version}";
  version = "1.6.6";

  src = fetchurl {
    url = "mirror://sourceforge/msmtp/${name}.tar.xz";
    sha256 = "0ppvww0sb09bnsrpqnvlrn8vx231r24xn2iiwpy020mxc8gxn5fs";
  };

  patches = [
    ./paths.patch
  ];

  buildInputs = [ openssl gnutls gsasl libidn ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags =
    stdenv.lib.optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  postInstall = ''
    substitute scripts/msmtpq/msmtpq $out/bin/msmtpq \
      --replace @msmtp@      $out/bin/msmtp \
      --replace @nc@         ${netcat-gnu}/bin/nc \
      --replace @journal@    ${journal} \
      ${lib.optionalString (journal == "y") "--replace @systemdcat@ ${systemd}/bin/systemd-cat" } \
      --replace @test@       ${tester}

    substitute scripts/msmtpq/msmtp-queue $out/bin/msmtp-queue \
      --replace @msmtpq@ $out/bin/msmtpq

    chmod +x $out/bin/*
  '';

  meta = with stdenv.lib; {
    description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
    homepage = http://msmtp.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ garbas peterhoeg ];
    platforms = platforms.unix;
  };
}
