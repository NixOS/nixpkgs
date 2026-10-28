{
  buildGoModule,
  buildNpmPackage,
  runCommand,
  runCommandCC,
  fetchFromGitHub,
  lib,
  nixosTests,
  pomerium-cli,
  patchelf,
  moreutils,
  jq,
}:

let
  inherit (lib)
    concatStringsSep
    concatMap
    id
    mapAttrsToList
    ;

  version = "0.33.4";
  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    hash = "sha256-oXq7ZZt2DsgUEIB8BvxbTMWVUD5kaLgG8KssYYk8yQg=";
  };
  vendorHash = "sha256-CZGgCEUfUj2+7G9OpRrhJvZ3exFxAqWYsBmUd59pYPo=";

  # Needed because buildGoModule does not support go workspaces yet.
  # We use Go's workspace vendor command.
  overrideModAttrs = _: {
    buildPhase = ''
      runHook preBuild

      go work vendor -e -v

      runHook postBuild
    '';
  };

  getEnvoy = buildGoModule {
    pname = "pomerium-get-envoy";
    inherit
      src
      version
      vendorHash
      overrideModAttrs
      ;

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
  inherit
    src
    version
    vendorHash
    overrideModAttrs
    ;

  envoyBinariesRaw =
    runCommand "pomerium-envoy-binaries-raw"
      {
        nativeBuildInputs = [ getEnvoy ];

        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = "sha256-SX+LpYGwMb33eVRo6TO7rPUfSlMMfD0N4zvZZRnkG2w=";

        meta = {
          homepage = "https://github.com/pomerium/envoy-custom";
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        };
      }
      ''
        mkdir $out
        cd $out
        get-envoy
        chmod +x envoy-darwin-arm64 envoy-linux-amd64 envoy-linux-arm64
      '';
  envoyBinaries =
    runCommandCC "pomerium-envoy-binaries"
      {
        nativeBuildInputs = [
          patchelf
          moreutils
          jq
        ];
      }
      ''
        mkdir $out
        cp ${finalAttrs.envoyBinariesRaw}/* $out
        chmod -R +w $out

        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/envoy-linux-amd64
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/envoy-linux-arm64
        jq ".digest = \"sha256:$(sha256sum $out/envoy-linux-amd64 | cut -f1 -d' ')\"" $out/envoy-linux-amd64.lock | sponge $out/envoy-linux-amd64.lock
        jq ".digest = \"sha256:$(sha256sum $out/envoy-linux-arm64 | cut -f1 -d' ')\"" $out/envoy-linux-arm64.lock | sponge $out/envoy-linux-arm64.lock
      '';

  ui = buildNpmPackage {
    pname = "pomerium-ui";
    inherit (finalAttrs) version;
    src = "${finalAttrs.src}/ui";

    npmDepsHash = "sha256-Vag3gRsCMCMcf+aPE9MRLweZkiFsY6FjGdlkhgC1CBg=";

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
