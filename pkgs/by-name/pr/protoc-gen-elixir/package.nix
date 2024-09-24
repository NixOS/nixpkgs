{
  beamPackages,
  fetchFromGitHub,
  lib,
}:
beamPackages.mixRelease rec {
  pname = "protoc-gen-elixir";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "elixir-protobuf";
    repo = "protobuf";
    rev = "refs/tags/v${version}";
    hash = "sha256-wLU3iM9jI/Zc96/HfPUjNvjteGryWos6IobIb/4zqpw=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit version src;
    pname = "protoc-gen-elixir-deps";

    hash = "sha256-H7yiBHoxuiqWcNbWwPU5X0Nnv8f6nM8z/ZAfZAGPZjE=";
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
