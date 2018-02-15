{ stdenv, lib, go, procps, removeReferencesTo, fetchFromGitHub }:

let
  common =
    args@{ name, target, installPhase }:

    stdenv.mkDerivation rec {
      version = "0.14.44";
      name = "${args.name}-${version}";

      src = fetchFromGitHub {
        owner  = "syncthing";
        repo   = "syncthing";
        rev    = "v${version}";
        sha256 = "1gdkx6lbzmdz2hqc9slbq41rwgkxmdisnj0iywx4mppmc2b4v6wh";
      };

      buildInputs = [ go removeReferencesTo ];

      buildPhase = ''
        # Syncthing expects that it is checked out in $GOPATH, if that variable is
        # set.  Since this isn't true when we're fetching source, we can explicitly
        # unset it and force Syncthing to set up a temporary one for us.
        env GOPATH= go run build.go -no-upgrade -version v${version} build ${target}
      '';

      inherit (args) installPhase;

      preFixup = ''
        find $out/bin -type f -exec remove-references-to -t ${go} '{}' '+'
      '';

      meta = with lib; {
        homepage = https://www.syncthing.net/;
        description = "Open Source Continuous File Synchronization";
        license = licenses.mpl20;
        maintainers = with maintainers; [ pshendry joko peterhoeg ];
        platforms = platforms.unix;
      };
    };

in {
  syncthing = common {
    name = "syncthing";
    target = "syncthing";

    installPhase = ''
      mkdir -p $out/lib/systemd/{system,user}

      install -Dm755 syncthing $out/bin/syncthing

      # This installs man pages in the correct directory according to the suffix
      # on the filename
      for mf in man/*.[1-9]; do
        mantype="$(echo "$mf" | awk -F"." '{print $NF}')"
        mandir="$out/share/man/man$mantype"
        mkdir -p "$mandir"
        install -Dm644 "$mf" "$mandir/$(basename "$mf")"
      done

    '' + lib.optionalString (stdenv.isLinux) ''
      substitute etc/linux-systemd/system/syncthing-resume.service \
                 $out/lib/systemd/system/syncthing-resume.service \
                 --replace /usr/bin/pkill ${procps}/bin/pkill

      substitute etc/linux-systemd/system/syncthing@.service \
                 $out/lib/systemd/system/syncthing@.service \
                 --replace /usr/bin/syncthing $out/bin/syncthing

      substitute etc/linux-systemd/user/syncthing.service \
                 $out/lib/systemd/user/syncthing.service \
                 --replace /usr/bin/syncthing $out/bin/syncthing
    '';
  };

  syncthing-discovery = common {
    name = "syncthing-discovery";
    target = "stdiscosrv";

    installPhase = ''
      install -Dm755 stdiscosrv $out/bin/stdiscosrv
    '';
  };

  syncthing-relay = common {
    name = "syncthing-relay";
    target = "strelaysrv";

    installPhase = ''
      mkdir -p $out/lib/systemd/system $out/bin

      install -Dm755 strelaysrv $out/bin/strelaysrv
    '' + lib.optionalString (stdenv.isLinux) ''
      substitute cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
                 $out/lib/systemd/system/strelaysrv.service \
                 --replace /usr/bin/strelaysrv $out/bin/strelaysrv
    '';
  };
}
