{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

let
  inherit (lib)
    concatStringsSep
    concatMap
    id
    mapAttrsToList
    ;
in
buildGoModule (finalAttrs: {
  pname = "pomerium-cli";
  version = "0.32.2";

  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-t2Sp4zAIybUsxaBdQ9ev+EJsFpWqM8KWaE2UOI4xw5A=";
  };

  vendorHash = "sha256-LzXcHGRBn99WhDsxLQKY3t8Zp4sw9Ec5CbA/rU/3SQ0=";

  subPackages = [
    "cmd/pomerium-cli"
  ];

  ldflags =
    let
      # Set a variety of useful meta variables for stamping the build with.
      setVars = {
        "github.com/pomerium/cli/version" = {
          Version = "v${finalAttrs.version}";
          BuildMeta = "nixpkgs";
          ProjectName = "pomerium-cli";
          ProjectURL = "github.com/pomerium/cli";
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

  installPhase = ''
    runHook preInstall

    install -Dm0755 $GOPATH/bin/pomerium-cli $out/bin/pomerium-cli

    runHook postInstall
  '';

  meta = {
    homepage = "https://pomerium.io";
    description = "Client-side helper for Pomerium authenticating reverse proxy";
    mainProgram = "pomerium-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
})
