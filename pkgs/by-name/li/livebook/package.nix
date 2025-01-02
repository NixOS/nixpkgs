{
  lib,
  beamPackages,
  makeWrapper,
  rebar3,
  elixir,
  erlang,
  fetchFromGitHub,
  nixosTests,
}:
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.14.4";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    rev = "v${version}";
    hash = "sha256-XpBJlPLr7E3OqTnLxnSmKCgDyiU1hT8WfOhWeRGYROA=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-jB6IOBX3LwdrEtaWY3gglo1HO2OhdiK8j3BgzfZ1nAU=";
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

  passthru.tests = {
    livebook-service = nixosTests.livebook-service;
  };

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://livebook.dev/";
    description = "Automate code & data workflows with interactive Elixir notebooks";
    maintainers = with maintainers; [
      munksgaard
      scvalex
    ];
    platforms = platforms.unix;
  };
}
