{ buildGoModule, stdenv, lib, procps, fetchFromGitHub, nixosTests }:

let
  common = { stname, target, postInstall ? "" }:
    buildGoModule rec {
      pname = stname;
      version = "1.23.0";

      src = fetchFromGitHub {
        owner = "syncthing";
        repo = "syncthing";
        rev = "v${version}";
        hash = "sha256-Z4YVU45na4BgIbN/IlORpTCuf2EuSuOyppDRzswn3EI=";
      };

      vendorHash = "sha256-q63iaRxJRvPY0Np20O6JmdMEjSg/kxRneBfs8fRTwXk=";

      doCheck = false;

      BUILD_USER = "nix";
      BUILD_HOST = "nix";

      buildPhase = ''
        runHook preBuild
        go run build.go -no-upgrade -version v${version} build ${target}
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dm755 ${target} $out/bin/${target}
        runHook postInstall
      '';

      inherit postInstall;

      passthru.tests = {
        inherit (nixosTests) syncthing syncthing-init syncthing-relay;
      };

      meta = with lib; {
        homepage = "https://syncthing.net/";
        description = "Open Source Continuous File Synchronization";
        changelog = "https://github.com/syncthing/syncthing/releases/tag/v${version}";
        license = licenses.mpl20;
        maintainers = with maintainers; [ joko peterhoeg andrew-d ];
        mainProgram = target;
        platforms = platforms.unix;
      };
    };

in
{
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
