{ resholve
, stdenv
, symlinkJoin
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, bash
, coreutils
, gnugrep
, gnutls
, gsasl
, libidn2
, netcat-gnu
, texinfo
, which
, Security
, withKeyring ? true
, libsecret ? null
, withSystemd ? stdenv.isLinux
, systemd ? null
}:

let
  inherit (lib) getBin getExe optionals;

  version = "1.8.20";

  src = fetchFromGitHub {
    owner = "marlam";
    repo = "msmtp-mirror";
    rev = "msmtp-${version}";
    hash = "sha256-RcQZ7Vm8UjJJoogkmUmZ+/2fz7C4AcVYY/kTOlfz7+I=";
  };

  meta = with lib; {
    description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
    homepage = "https://marlam.de/msmtp/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };

  binaries = stdenv.mkDerivation rec {
    pname = "msmtp-binaries";
    inherit version src meta;

    configureFlags = [ "--sysconfdir=/etc" "--with-libgsasl" ]
      ++ optionals stdenv.isDarwin [ "--with-macosx-keyring" ];

    buildInputs = [ gnutls gsasl libidn2 ]
      ++ optionals stdenv.isDarwin [ Security ]
      ++ optionals withKeyring [ libsecret ];

    nativeBuildInputs = [ autoreconfHook pkg-config texinfo ];

    enableParallelBuilding = true;

    postInstall = ''
      install -Dm444 -t $out/share/doc/msmtp doc/*.example
      ln -s msmtp $out/bin/sendmail
    '';
  };

  scripts = resholve.mkDerivation rec {
    pname = "msmtp-scripts";
    inherit version src meta;

    patches = [ ./paths.patch ];

    postPatch = ''
      substituteInPlace scripts/msmtpq/msmtpq \
        --replace @journal@ ${if withSystemd then "Y" else "N"}
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm555 -t $out/bin                     scripts/msmtpq/msmtp*
      install -Dm444 -t $out/share/doc/msmtp/scripts scripts/msmtpq/README*
      install -Dm444 -t $out/share/doc/msmtp/scripts scripts/{find_alias,msmtpqueue,set_sendmail}/*

      if grep --quiet -E '@.+@' $out/bin/*; then
        echo "Unsubstituted variables found. Aborting!"
        grep -E '@.+@' $out/bin/*
        exit 1
      fi

      runHook postInstall
    '';

    solutions = {
      msmtpq = {
        scripts = [ "bin/msmtpq" ];
        interpreter = getExe bash;
        inputs = [
          binaries
          coreutils
          gnugrep
          netcat-gnu
          which
        ] ++ optionals withSystemd [ systemd ];
        execer = [
          "cannot:${getBin binaries}/bin/msmtp"
          "cannot:${getBin netcat-gnu}/bin/nc"
        ] ++ optionals withSystemd [
          "cannot:${getBin systemd}/bin/systemd-cat"
        ];
        fix."$MSMTP" = [ "msmtp" ];
        fake.external = [ "ping" ]
          ++ optionals (!withSystemd) [ "systemd-cat" ];
      };

      msmtp-queue = {
        scripts = [ "bin/msmtp-queue" ];
        interpreter = getExe bash;
        inputs = [ "${placeholder "out"}/bin" ];
        execer = [ "cannot:${placeholder "out"}/bin/msmtpq" ];
      };
    };
  };

in
symlinkJoin {
  name = "msmtp-${version}";
  inherit version meta;
  paths = [ binaries scripts ];
}
