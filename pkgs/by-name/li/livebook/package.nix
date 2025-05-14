{
  lib,
  beamPackages,
  makeWrapper,
  rebar3,
  elixir,
  erlang,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.14.7";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-8/u/1I3pSfxyF35ZnqClR7FXPL2rhBDdf4w/KUGjVVs=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-FrkM82LO7GIFpKQfhlEUrAuKu33BzPBs6OrWW4C6pI0=";
  };

  postInstall = ''
    wrapProgram $out/bin/livebook \
      --prefix PATH : ${
        lib.makeBinPath [
          elixir
          erlang
        ]
      } \
      --set MIX_REBAR3 ${rebar3}/bin/rebar3
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
