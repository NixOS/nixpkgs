{ stdenv, lib, fetchurl, fetchFromGitHub, autoreconfHook, pkgconfig
, openssl, netcat-gnu, gnutls, gsasl, libidn, Security
, systemd ? null, eject ? null }:

let
  tester = "n"; # {x| |p|P|n|s}
  journal = if stdenv.isLinux then "y" else "n";

  # preferNonBlock = stdenv.isLinux;
  preferNonBlock = false;

  nonblock = fetchFromGitHub {
    owner  = "Stebalien";
    repo   = "msmtp-queue";
    rev    = "07032a4e4c8ea0d2364641c959db0c60f52423c7";
    sha256 = "0g2aph30007spkdwxljrlr2bliivf9nrdis3d3jvjpx8l6k60rr9";
  };

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
    ++ lib.optional stdenv.isDarwin Security
    ++ lib.optionals preferNonBlock [ nonblock eject ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  configureFlags =
    stdenv.lib.optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  postInstall = ''
    ${lib.optionalString (!preferNonBlock) ''
    substitute scripts/msmtpq/msmtpq $out/bin/msmtpq \
      --replace @msmtp@      $out/bin/msmtp \
      --replace @nc@         ${netcat-gnu}/bin/nc \
      --replace @journal@    ${journal} \
      ${lib.optionalString (journal == "y") "--replace @systemdcat@ ${systemd}/bin/systemd-cat" } \
      --replace @test@       ${tester}

    substitute scripts/msmtpq/msmtp-queue $out/bin/msmtp-queue \
      --replace @msmtpq@ $out/bin/msmtpq
    ''}
    ${lib.optionalString preferNonBlock ''
    mkdir -p $out/lib/systemd/user
    cp ${nonblock}/msmtp* $out/bin/
    cp ${nonblock}/systemd/* $out/lib/systemd/user
    for f in $out/bin/msmtpq* ; do
      sed $f -i -r \
        -e 's|^QUEUE_DIR.*|QUEUE_DIR="''${MSMTP_QUEUE:-''${XDG_DATA_HOME:-$HOME/.local/share}/mail.queue}"|' \
        -e 's|^CONFIG.*|CONFIG="''${XDG_CONFIG_HOME:-$HOME/.config}/msmtprc"|' \
        -e 's| flock | ${eject}/bin/flock |'
    done
    for f in $out/lib/systemd/user/* ; do
      substituteInPlace $f \
        --replace /usr/local               $out \
        --replace .local/share/mail.queue  .cache/msmtp/queue
    done
    ''}

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
