{
  buildGoModule,
  buildNpmPackage,
  runCommand,
  fetchFromGitHub,
  lib,
  nixosTests,
  pomerium-cli,
}:

let
  inherit (lib)
    concatStringsSep
    concatMap
    id
    mapAttrsToList
    ;

  version = "0.32.7";
  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    hash = "sha256-JPRyLQzQmC3EiIp+rOMx24JVneFUN7ovC2eYrKxf3ik=";
  };
  vendorHash = "sha256-ST33a/YNJiE70ORWNxS9gFNfHcNGGiQhOpUwqgbEJiQ=";

  getEnvoy = buildGoModule {
    pname = "pomerium-get-envoy";
    inherit src version vendorHash;

    subPackages = [
      "pkg/envoy/get-envoy"
    ];

    # get-envoy's envoy version is pinned via pkg/envoy/envoyversion, which
    # relies on a specific version of github.com/pomerium/envoy-custom as a Go module,
    # and then fetches that version's release binaries from GHCR.
  };
in
buildGoModule (finalAttrs: {
  pname = "pomerium";
  inherit src version vendorHash;

  envoyBinaries =
    runCommand "pomerium-envoy-binaries"
      {
        nativeBuildInputs = [ getEnvoy ];

        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = "sha256-i2DuOx+fSCwTKavf6zvuRd1AKbk4igrzy2AXinDkyrI=";

        meta = {
          homepage = "https://github.com/pomerium/envoy-custom";
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        };
      }
      ''
        mkdir $out
        cd $out
        get-envoy
        chmod +x envoy-darwin-amd64 envoy-darwin-arm64 envoy-linux-amd64 envoy-linux-arm64
      '';

  ui = buildNpmPackage {
    pname = "pomerium-ui";
    inherit (finalAttrs) version;
    src = "${finalAttrs.src}/ui";

    npmDepsHash = "sha256-2fzINp3LBPHPJlzJnUggPWUZHrjuX9TYPD2XvioonSw=";

    installPhase = ''
      runHook preInstall
      cp -R dist $out
      runHook postInstall
    '';
  };

  subPackages = [
    "cmd/pomerium"
  ];

  ldflags =
    let
      # Set a variety of useful meta variables for stamping the build with.
      setVars = {
        "github.com/pomerium/pomerium/internal/version" = {
          Version = "v${finalAttrs.version}";
          BuildMeta = "nixpkgs";
          ProjectName = "pomerium";
          ProjectURL = "github.com/pomerium/pomerium";
        };
      };
      concatStringsSpace = list: concatStringsSep " " list;
      mapAttrsToFlatList = fn: list: concatMap id (mapAttrsToList fn list);
      varFlags = concatStringsSpace (
        mapAttrsToFlatList (
          package: packageVars:
          mapAttrsToList (variable: value: "-X ${package}.${variable}=${value}") packageVars
        ) setVars
      );
    in
    [
      "${varFlags}"
    ];

  preBuild = ''
    # Insert embedded envoy.
    cp -r ${finalAttrs.envoyBinaries}/* pkg/envoy/files

    # put the built UI files where they will be picked up as part of binary build
    cp -r ${finalAttrs.ui}/* ui/dist
  '';

  installPhase = ''
    install -Dm0755 $GOPATH/bin/pomerium $out/bin/pomerium
  '';

  passthru = {
    tests = {
      inherit (nixosTests) pomerium;
      inherit pomerium-cli;
    };
    updateScript = ./updater.sh;
  };

  meta = {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    mainProgram = "pomerium";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lukegb
      devusb
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
