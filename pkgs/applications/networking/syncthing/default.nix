{ buildGoPackage, fetchpatch, stdenv, lib, procps, fetchFromGitHub }:

let
  common = { stname, target, postInstall ? "" }:
    buildGoPackage rec {
      version = "1.0.0";
      name = "${stname}-${version}";

      src = fetchFromGitHub {
        owner  = "syncthing";
        repo   = "syncthing";
        rev    = "v${version}";
        sha256 = "1qkjnij9jw3d4pjkdr6npz5ps604qg6g36jnsng0k1r2qnrydnwh";
      };

      goPackagePath = "github.com/syncthing/syncthing";

      patches = [
        ./add-stcli-target.patch
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
      mkdir -p $bin/lib/systemd/{system,user}

      substitute etc/linux-systemd/system/syncthing-resume.service \
                 $bin/lib/systemd/system/syncthing-resume.service \
                 --replace /usr/bin/pkill ${procps}/bin/pkill

      substitute etc/linux-systemd/system/syncthing@.service \
                 $bin/lib/systemd/system/syncthing@.service \
                 --replace /usr/bin/syncthing $bin/bin/syncthing

      substitute etc/linux-systemd/user/syncthing.service \
                 $bin/lib/systemd/user/syncthing.service \
                 --replace /usr/bin/syncthing $bin/bin/syncthing
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
                 --replace /usr/bin/strelaysrv $bin/bin/strelaysrv
    '';
  };
}
