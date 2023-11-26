{ pkgsBuildBuild
, go
, buildGoModule
, stdenv
, lib
, procps
, fetchFromGitHub
, nixosTests
, autoSignDarwinBinariesHook
}:

let
  common = { stname, target, postInstall ? "" }:
    buildGoModule rec {
      pname = stname;
      version = "1.26.1";

      src = fetchFromGitHub {
        owner = "syncthing";
        repo = "syncthing";
        rev = "v${version}";
        hash = "sha256-R7JTHlNP1guKRfiDjPVi1lnvfUAXuPDNDAMTGmbj3Hc=";
      };

      vendorHash = "sha256-XYXIj+7xe33hCYM6Z9tqGSgr/P0LVlaPNf3T0PrxU7I=";

      nativeBuildInputs = lib.optionals stdenv.isDarwin [
        # Recent versions of macOS seem to require binaries to be signed when
        # run from Launch Agents/Daemons, even on x86 devices where it has a
        # more lax code signing policy compared to Apple Silicon. So just sign
        # the binaries on both architectures to make it possible for launchd to
        # auto-start Syncthing at login.
        autoSignDarwinBinariesHook
      ];

      doCheck = false;

      BUILD_USER = "nix";
      BUILD_HOST = "nix";

      buildPhase = ''
        runHook preBuild
        (
          export GOOS="${pkgsBuildBuild.go.GOOS}" GOARCH="${pkgsBuildBuild.go.GOARCH}" CC=$CC_FOR_BUILD
          go build build.go
          go generate github.com/syncthing/syncthing/lib/api/auto github.com/syncthing/syncthing/cmd/strelaypoolsrv/auto
        )
        ./build -goos ${go.GOOS} -goarch ${go.GOARCH} -no-upgrade -version v${version} build ${target}
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
