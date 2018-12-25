{ buildGoPackage, fetchpatch, stdenv, lib, procps, fetchFromGitHub }:

let
  common = { stname, target, postInstall ? "" }:
    buildGoPackage rec {
      version = "0.14.54";
      name = "${stname}-${version}";

      src = fetchFromGitHub {
        owner  = "syncthing";
        repo   = "syncthing";
        rev    = "v${version}";
        sha256 = "0l73ka71l6gxv46wmlyzj8zhfpfj3vf6nv6x3x0z25ymr3wa2fza";
      };

      goPackagePath = "github.com/syncthing/syncthing";

      patches = [
        ./add-stcli-target.patch
        (fetchpatch {
          url = "https://github.com/syncthing/syncthing/commit/e7072feeb7669948c3e43f55d21aec15481c33ba.patch";
          sha256 = "1pcybww2vdx45zhd1sd53v7fp40vfgkwqgy8flv7hxw2paq8hxd4";
        })
      ];
      BUILD_USER="nix";
      BUILD_HOST="nix";

      buildPhase = ''
        runHook preBuild
        pushd go/src/${goPackagePath}
        go run build.go -no-upgrade -version v${version} build ${target}
        popd
        runHook postBuild
      '';

      installPhase = ''
        pushd go/src/${goPackagePath}
        runHook preInstall
        install -Dm755 ${target} $bin/bin/${target}
        runHook postInstall
        popd
      '';

      inherit postInstall;

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
