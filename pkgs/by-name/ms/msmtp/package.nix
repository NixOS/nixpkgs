{
  resholve,
  stdenv,
  symlinkJoin,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bash,
  coreutils,
  gnugrep,
  gnused,
  gnutls,
  gsasl,
  libidn2,
  netcat-gnu,
  texinfo,
  which,
  withKeyring ? true,
  libsecret,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  withScripts ? true,
  withLibnotify ? true,
  libnotify,
  gitUpdater,
  binlore,
  msmtp,
}:

let
  inherit (lib) getBin getExe optionals;

  version = "1.8.32";

  src = fetchFromGitHub {
    owner = "marlam";
    repo = "msmtp";
    rev = "msmtp-${version}";
    hash = "sha256-ofyDtP7KgTKX/O1O4g3OcDwgihDveAiJ5s5GQtSqf28=";
  };

  meta = with lib; {
    description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
    homepage = "https://marlam.de/msmtp/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "msmtp";
  };

  binaries = stdenv.mkDerivation {
    pname = "msmtp-binaries";
    inherit version src meta;

    configureFlags = [
      "--sysconfdir=/etc"
      "--with-libgsasl"
    ]
    ++ optionals stdenv.hostPlatform.isDarwin [ "--with-macosx-keyring" ];

    buildInputs = [
      gnutls
      gsasl
      libidn2
    ]
    ++ optionals withKeyring [ libsecret ];

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      texinfo
    ];

    enableParallelBuilding = true;

    postInstall = ''
      install -Dm444 -t $out/share/doc/msmtp doc/*.example
      ln -s msmtp $out/bin/sendmail
    '';
  };

  scripts = resholve.mkDerivation {
    pname = "msmtp-scripts";
    inherit version src meta;

    patches = [
      ./msmtpq-remove-binary-check.patch
      ./msmtpq-systemd-logging.patch
    ];

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
          gnused
          netcat-gnu
          which
        ]
        ++ optionals withSystemd [ systemd ]
        ++ optionals withLibnotify [ libnotify ];
        execer = [
          "cannot:${getBin binaries}/bin/msmtp"
          "cannot:${getBin netcat-gnu}/bin/nc"
        ]
        ++ optionals withSystemd [
          "cannot:${getBin systemd}/bin/systemd-cat"
        ]
        ++ optionals withLibnotify [
          "cannot:${getBin libnotify}/bin/notify-send"
        ];
        fix."$MSMTP" = [ "msmtp" ];
        fake.external = [
          "ping"
        ]
        ++ optionals (!withSystemd) [ "systemd-cat" ]
        ++ optionals (!withLibnotify) [ "notify-send" ];
        keep.source = [ "~/.msmtpqrc" ];
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
if withScripts then
  symlinkJoin {
    name = "msmtp-${version}";
    inherit version meta;
    paths = [
      binaries
      scripts
    ];
    passthru = {
      inherit binaries scripts src;
      # msmtpq forwards most of its arguments to msmtp [1].
      #
      # [1]: <https://github.com/marlam/msmtp/blob/msmtp-1.8.26/scripts/msmtpq/msmtpq#L301>
      binlore.out = binlore.synthesize msmtp ''
        wrapper bin/msmtpq bin/msmtp
      '';
      updateScript = gitUpdater { rev-prefix = "msmtp-"; };
    };
  }
else
  binaries
