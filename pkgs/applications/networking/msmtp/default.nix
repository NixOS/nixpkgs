{ stdenv, lib, fetchurl, fetchpatch, autoreconfHook, pkgconfig, texinfo
, netcat-gnu, gnutls, gsasl, libidn2, Security
, withKeyring ? true, libsecret ? null
, systemd ? null }:

let
  tester = "n"; # {x| |p|P|n|s}
  journal = if stdenv.isLinux then "y" else "n";

in stdenv.mkDerivation rec {
  pname = "msmtp";
  version = "1.8.8";

  src = fetchurl {
    url = "https://marlam.de/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "1rarck61mz3mwg0l30vjj6j9fq6gc7gic0r1c1ppwpq2izj57jzc";
  };

  # the 2nd patch should go when 1.8.9 is released
  patches = [
    ./paths.patch
    (fetchpatch {
      url = "https://github.com/marlam/msmtp-mirror/commit/c78f24347ec996c7a3830b48403bf3736afca071.patch";
      sha256 = "0d4sc2f5838jriv65wahpgvwckkzqhdk3hs660fyg80si2i0l1bx";
    })
  ];

  buildInputs = [ gnutls gsasl libidn2 ]
    ++ stdenv.lib.optional stdenv.isDarwin Security
    ++ stdenv.lib.optional withKeyring libsecret;

  nativeBuildInputs = [ autoreconfHook pkgconfig texinfo ];

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
    homepage = "https://marlam.de/msmtp/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };


}
