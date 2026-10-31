{
  beamPackages,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
let
  inherit (beamPackages) mixRelease fetchMixDeps;
in
mixRelease rec {
  pname = "protoc-gen-elixir";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "elixir-protobuf";
    repo = "protobuf";
    tag = "v${version}";
    hash = "sha256-XSTB4MATvLf1sj5O1QEc62Jm3PUR9Wt4tKY03xW4yvI=";
  };

  mixFodDeps = fetchMixDeps {
    inherit version src;
    pname = "protoc-gen-elixir-deps";

    hash = "sha256-T1uL3xXXmCkobJJhS3p6xMrJUyiim3AMwaG87/Ix7A8=";
  };

  escriptBinName = "protoc-gen-elixir";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protoc plugin to generate Elixir code";
    mainProgram = "protoc-gen-elixir";
    homepage = "https://github.com/elixir-protobuf/protobuf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattpolzin ];
  };
}
