{
  beamPackages,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
let
  inherit (beamPackages) mixRelease fetchMixDeps erlang;
in
mixRelease rec {
  pname = "protoc-gen-elixir";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "elixir-protobuf";
    repo = "protobuf";
    tag = "v${version}";
    hash = "sha256-kyS9KZENdoEuB64k48RegtZQa57/RDnm8bY+piAAk2w=";
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
