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
  version = "0.16.2";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-x4h5vT2p1SL/8p04DRpKbIbwL7XzctH27f4ZAwj0QOg=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-0gmUCVLrNfcRCPhaXuOfrYW05TDbDN5Zt9IA8OBU8Gc=";
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
