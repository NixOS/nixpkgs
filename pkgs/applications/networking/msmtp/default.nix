{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig
, netcat-gnu, gnutls, gsasl, libidn2, Security
, withKeyring ? true, libsecret ? null
, systemd ? null }:

let
  tester = "n"; # {x| |p|P|n|s}
  journal = if stdenv.isLinux then "y" else "n";

in stdenv.mkDerivation rec {
  pname = "msmtp";
  version = "1.8.4";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "1xr926lyy44baqdgv9q0sw5z6ll2cb4lx2g4lgpgbqn8bglpzpg5";
  };

  patches = [
    ./paths.patch
  ];

  buildInputs = [ gnutls gsasl libidn2 ]
    ++ stdenv.lib.optional stdenv.isDarwin Security
    ++ stdenv.lib.optional withKeyring libsecret;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags =
    [ "--sysconfdir=/etc" ] ++ stdenv.lib.optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  postInstall = ''
    install -d $out/share/doc/${pname}/scripts
    cp -r scripts/{find_alias,msmtpqueue,msmtpq,set_sendmail} $out/share/doc/${pname}/scripts
    install -Dm644 doc/*.example $out/share/doc/${pname}

    substitute scripts/msmtpq/msmtpq $out/bin/msmtpq \
      --replace @msmtp@      $out/bin/msmtp \
      --replace @nc@         ${netcat-gnu}/bin/nc \
      --replace @journal@    ${journal} \
      ${lib.optionalString (journal == "y") "--replace @systemdcat@ ${systemd}/bin/systemd-cat" } \
      --replace @test@       ${tester}

    substitute scripts/msmtpq/msmtp-queue $out/bin/msmtp-queue \
      --replace @msmtpq@ $out/bin/msmtpq

    ln -s msmtp $out/bin/sendmail

    chmod +x $out/bin/*
  '';

  meta = with stdenv.lib; {
    description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
    homepage = https://marlam.de/msmtp/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ garbas peterhoeg ];
    platforms = platforms.unix;
  };
}
