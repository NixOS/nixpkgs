{
  beamPackages,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
beamPackages.mixRelease rec {
  pname = "protoc-gen-elixir";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "elixir-protobuf";
    repo = "protobuf";
    tag = "v${version}";
    hash = "sha256-SbwjOFTyN3euMNXkuIP49zNqoXmD8611IXgqPwqfuFU=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit version src;
    pname = "protoc-gen-elixir-deps";

    hash = "sha256-T1uL3xXXmCkobJJhS3p6xMrJUyiim3AMwaG87/Ix7A8=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A protoc plugin to generate Elixir code";
    mainProgram = "protoc-gen-elixir";
    homepage = "https://github.com/elixir-protobuf/protobuf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattpolzin ];
  };
}
