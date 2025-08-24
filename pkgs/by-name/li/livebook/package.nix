{
  lib,
  beamMinimal28Packages,
  makeWrapper,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
let
  beamPackages = beamMinimal28Packages;
in
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.16.4";

  inherit (beamPackages) elixir;

  buildInputs = [ beamPackages.erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-Cwzcoslqjaf7z9x2Sgnzrrl4zUcH2f7DEWaFPBIi3ms=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-OEYkWh0hAl7ZXP2Cq+TgVGF4tnWlpF6W5uRSdyrswlA=";
  };

  postInstall = ''
    wrapProgram $out/bin/livebook \
      --prefix PATH : ${
        lib.makeBinPath [
          beamPackages.elixir
          beamPackages.erlang
        ]
      } \
      --set MIX_REBAR3 ${beamPackages.rebar3}/bin/rebar3
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      livebook-service = nixosTests.livebook-service;
    };
  };

  meta = {
    license = lib.licenses.asl20;
    homepage = "https://livebook.dev/";
    description = "Automate code & data workflows with interactive Elixir notebooks";
    maintainers = with lib.maintainers; [
      munksgaard
      scvalex
    ];
    platforms = lib.platforms.unix;
  };
}
