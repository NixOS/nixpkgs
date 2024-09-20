{
  lib,

  beam_minimal,
  fetchFromGitHub,
}:

let
  beamPackages = beam_minimal.packages.erlang_27;
  elixir = beamPackages.elixir_1_17;
in

beamPackages.mixRelease rec {
  pname = "next-ls";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "elixir-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jI7/BcS9CimCQskXd7Cq3EGPuc9l4L7Gre8hor58ags=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit src version elixir;
    pname = "next-ls-deps";
    hash = "sha256-4Rt5Q0fX+fbncvxyXdpIhgEvn9VYX/QDxDdnbanT21Q=";
  };

  inherit elixir;
  inherit (beamPackages) erlang;

  removeCookie = false;

  # replace installPhase to change release target
  installPhase = ''
    runHook preInstall

    mix release --no-deps-check --path $out plain
    makeWrapper $out/bin/plain $out/bin/nextls --add-flags "eval \"System.no_halt(true); Application.ensure_all_started(:next_ls)\""

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.elixir-tools.dev/next-ls/";
    changelog = "https://github.com/elixir-tools/next-ls/releases/tag/v${version}";
    description = "The language server for Elixir that just works";
    license = licenses.mit;
    mainProgram = "nextls";
    maintainers = [ maintainers.adamcstephens ];
    platforms = beamPackages.erlang.meta.platforms;
  };
}
