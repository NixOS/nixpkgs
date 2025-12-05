{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  lib,
  envoy,
  yarnConfigHook,
  yarnBuildHook,
  fetchYarnDeps,
  nodejs,
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
in
buildGoModule rec {
  pname = "pomerium";
  version = "0.30.5";
  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    hash = "sha256-3SmcuLEWqsw/B10jTIG2TKGa7tyMLa/lpkD6Iq/Fm4g=";
  };

  vendorHash = "sha256-mOTjBH8VqsMdyW5jTIZ76bf55WnHw9XuUSh6zsBktt0=";

  ui = stdenv.mkDerivation {
    pname = "pomerium-ui";
    inherit version;
    src = "${src}/ui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/ui/yarn.lock";
      hash = "sha256-V2nSSMvTCK+SYmEhTbLMArIOmNs/AgB5xfhQGx3e/x8=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];

    installPhase = ''
      runHook preInstall
      cp -R dist $out
      runHook postInstall
    '';
  };

  subPackages = [
    "cmd/pomerium"
  ];

  # patch pomerium to allow use of external envoy
  patches = [
    ./0001-envoy-allow-specification-of-external-binary.patch
  ];

  ldflags =
    let
      # Set a variety of useful meta variables for stamping the build with.
      setVars = {
        "github.com/pomerium/pomerium/internal/version" = {
          Version = "v${version}";
          BuildMeta = "nixpkgs";
          ProjectName = "pomerium";
          ProjectURL = "github.com/pomerium/pomerium";
        };
        "github.com/pomerium/pomerium/pkg/envoy" = {
          OverrideEnvoyPath = "${envoy}/bin/envoy";
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
    # Replace embedded envoy with nothing.
    # We set OverrideEnvoyPath above, so rawBinary should never get looked at
    # but we still need to set a checksum/version.
    rm pkg/envoy/files/files_{darwin,linux}*.go
    cat <<EOF >pkg/envoy/files/files_external.go
    package files

    import _ "embed" // embed

    var rawBinary []byte

    //go:embed envoy.sha256
    var rawChecksum string

    //go:embed envoy.version
    var rawVersion string
    EOF
    sha256sum '${envoy}/bin/envoy' > pkg/envoy/files/envoy.sha256
    echo '${envoy.version}' > pkg/envoy/files/envoy.version

    # put the built UI files where they will be picked up as part of binary build
    cp -r ${ui}/* ui/dist
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

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    mainProgram = "pomerium";
    license = licenses.asl20;
    maintainers = with maintainers; [
      lukegb
      devusb
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
