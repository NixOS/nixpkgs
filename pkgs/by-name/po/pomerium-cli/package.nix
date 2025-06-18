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
buildGoModule rec {
  pname = "pomerium-cli";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-CcXreKZ83+WDucV3sr62bwKzSs+S9R3e+z0JD0rR8jw=";
  };

  vendorHash = "sha256-k6HOIpz0cPCkP3TXg62u+tuYd41TF+YAoCWINAcFoB8=";

  subPackages = [
    "cmd/pomerium-cli"
  ];

  ldflags =
    let
      # Set a variety of useful meta variables for stamping the build with.
      setVars = {
        "github.com/pomerium/cli/version" = {
          Version = "v${version}";
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

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Client-side helper for Pomerium authenticating reverse proxy";
    mainProgram = "pomerium-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
