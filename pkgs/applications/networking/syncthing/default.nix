{ stdenv, lib, go, procps, removeReferencesTo, fetchFromGitHub }:

let
  common = { stname, target, patches ? [], postInstall ? "" }:
    stdenv.mkDerivation rec {
      version = "0.14.50";
      name = "${stname}-${version}";

      src = fetchFromGitHub {
        owner  = "syncthing";
        repo   = "syncthing";
        rev    = "v${version}";
        sha256 = "10lilw20mq1zshysb9zrszcpl4slyyxvnbxfqk04nhz0b1gmm9ri";
      };

      inherit patches;

      buildInputs = [ go ];
      nativeBuildInputs = [ removeReferencesTo ];

      buildPhase = ''
        # Syncthing expects that it is checked out in $GOPATH, if that variable is
        # set.  Since this isn't true when we're fetching source, we can explicitly
        # unset it and force Syncthing to set up a temporary one for us.
        env GOPATH= BUILD_USER=nix BUILD_HOST=nix go run build.go -no-upgrade -version v${version} build ${target}
      '';

      installPhase = ''
        install -Dm755 ${target} $out/bin/${target}
        runHook postInstall
      '';

      inherit postInstall;

      preFixup = ''
        find $out/bin -type f -exec remove-references-to -t ${go} '{}' '+'
      '';

      meta = with lib; {
        homepage = https://www.syncthing.net/;
        description = "Open Source Continuous File Synchronization";
        license = licenses.mpl20;
        maintainers = with maintainers; [ pshendry joko peterhoeg andrew-d ];
        platforms = platforms.unix;
      };
    };

in {
  syncthing = common {
    stname = "syncthing";
    target = "syncthing";

    postInstall = ''
      # This installs man pages in the correct directory according to the suffix
      # on the filename
      for mf in man/*.[1-9]; do
        mantype="$(echo "$mf" | awk -F"." '{print $NF}')"
        mandir="$out/share/man/man$mantype"
        install -Dm644 "$mf" "$mandir/$(basename "$mf")"
      done

    '' + lib.optionalString (stdenv.isLinux) ''
      mkdir -p $out/lib/systemd/{system,user}

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

  syncthing-cli = common {
    stname = "syncthing-cli";

    patches = [ ./add-stcli-target.patch ];
    target = "stcli";
  };

  syncthing-discovery = common {
    stname = "syncthing-discovery";
    target = "stdiscosrv";
  };

  syncthing-relay = common {
    stname = "syncthing-relay";
    target = "strelaysrv";

    postInstall = lib.optionalString (stdenv.isLinux) ''
      mkdir -p $out/lib/systemd/system

      substitute cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
                 $out/lib/systemd/system/strelaysrv.service \
                 --replace /usr/bin/strelaysrv $out/bin/strelaysrv
    '';
  };
}
