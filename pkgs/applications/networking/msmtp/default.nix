{ stdenv, lib, fetchpatch, fetchurl, autoreconfHook, pkgconfig
, openssl, netcat-gnu, gnutls, gsasl, libidn, Security
, withKeyring ? true, libsecret ? null
, systemd ? null }:

let
  tester = "n"; # {x| |p|P|n|s}
  journal = if stdenv.isLinux then "y" else "n";

in stdenv.mkDerivation rec {
  pname = "msmtp";
  name = "${pname}-${version}";
  version = "1.6.8";

  src = fetchurl {
    url = "https://marlam.de/msmtp/releases/${name}.tar.xz";
    sha256 = "1ysrnshvwhzwmvb2walw5i9jdzlvmckj7inr0xnvb26q0jirbzsm";
  };

  patches = [
    ./paths.patch

    # To support passwordeval commands that do not print a final
    # newline.
    (fetchpatch {
      name = "passwordeval-without-nl.patch";
      url = "https://gitlab.marlam.de/marlam/msmtp/commit/df22dccf9d1af06fcd09dfdd0d6a38e1372dd5e8.patch";
      sha256 = "06gbhvzi46zqigmmsin2aard7b9v3ihx62hbz5ljmfbj9rfs1x5y";
    })
  ];

  buildInputs = [ openssl gnutls gsasl libidn ]
    ++ stdenv.lib.optional stdenv.isDarwin Security
    ++ stdenv.lib.optional withKeyring libsecret;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags =
    stdenv.lib.optional stdenv.isDarwin [ "--with-macosx-keyring" ];

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
    license = licenses.gpl3;
    maintainers = with maintainers; [ garbas peterhoeg ];
    platforms = platforms.unix;
  };
}
