{
  beamPackages,
  fetchFromGitHub,
  lib,
}:
beamPackages.mixRelease rec {
  pname = "protoc-gen-elixir";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "elixir-protobuf";
    repo = "protobuf";
    rev = "refs/tags/v${version}";
    hash = "sha256-TnuIlXYr36hx1sVktPHj4J4cJLCFK5F1xaX0V9/+ICQ=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit version src;
    pname = "protoc-gen-elixir-deps";

    hash = "sha256-lFfAfKAM4O+yIBXgdCA+EPe1XAOaTIjTfpOFjITpvQ4=";
  };

  postBuild = ''
    mix do escript.build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp protoc-gen-elixir $out/bin

    runHook postInstall
  '';

  meta = {
    description = "A protoc plugin to generate Elixir code";
    mainProgram = "protoc-gen-elixir";
    homepage = "https://github.com/elixir-protobuf/protobuf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattpolzin ];
  };
}
