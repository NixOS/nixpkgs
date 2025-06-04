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
  version = "0.16.1";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-vZFmd9Y5KEnQqzvCmGKGUbY+yR7IEc+0n0sycPDMxa8=";
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
