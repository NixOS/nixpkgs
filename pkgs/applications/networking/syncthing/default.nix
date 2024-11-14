{ pkgsBuildBuild
, go
, buildGoModule
, stdenv
, lib
, fetchFromGitHub
, nixosTests
, autoSignDarwinBinariesHook
, nix-update-script
}:

let
  common = { stname, target, postInstall ? "" }:
    buildGoModule rec {
      pname = stname;
      version = "1.28.0";

      src = fetchFromGitHub {
        owner = "syncthing";
        repo = "syncthing";
        rev = "refs/tags/v${version}";
        hash = "sha256-JW78n/3hssH600uXn4YLxcIJylPbSpEZICtKmqfqamI=";
      };

      vendorHash = "sha256-9/PfiOSCInduQXZ47KbrD3ca9O0Zt+TP7XoX+HjwQgs=";

      nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
          go generate github.com/syncthing/syncthing/lib/api/auto github.com/syncthing/syncthing/cmd/infra/strelaypoolsrv/auto
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

      passthru = {
        tests = {
          inherit (nixosTests) syncthing syncthing-init syncthing-relay;
        };
        updateScript = nix-update-script { };
      };

      meta = {
        homepage = "https://syncthing.net/";
        description = "Open Source Continuous File Synchronization";
        changelog = "https://github.com/syncthing/syncthing/releases/tag/v${version}";
        license = lib.licenses.mpl20;
        maintainers = with lib.maintainers; [ joko peterhoeg ];
        mainProgram = target;
        platforms = lib.platforms.unix;
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

    '' + lib.optionalString (stdenv.hostPlatform.isLinux) ''
      mkdir -p $out/lib/systemd/{system,user}

      substitute etc/linux-systemd/system/syncthing@.service \
                 $out/lib/systemd/system/syncthing@.service \
                 --replace-fail /usr/bin/syncthing $out/bin/syncthing

      substitute etc/linux-systemd/user/syncthing.service \
                 $out/lib/systemd/user/syncthing.service \
                 --replace-fail /usr/bin/syncthing $out/bin/syncthing
    '';
  };

  syncthing-discovery = common {
    stname = "syncthing-discovery";
    target = "stdiscosrv";
  };

  syncthing-relay = common {
    stname = "syncthing-relay";
    target = "strelaysrv";

    postInstall = lib.optionalString (stdenv.hostPlatform.isLinux) ''
      mkdir -p $out/lib/systemd/system

      substitute cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
                 $out/lib/systemd/system/strelaysrv.service \
                 --replace-fail /usr/bin/strelaysrv $out/bin/strelaysrv
    '';
  };
}
