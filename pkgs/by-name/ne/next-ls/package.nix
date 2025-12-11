{
  lib,

  beamPackages,
  fetchFromGitHub,
}:

beamPackages.mixRelease rec {
  pname = "next-ls";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "elixir-tools";
    repo = "next-ls";
    tag = "v${version}";
    hash = "sha256-2KzBOzrfoQQIqjEtYufvhT9bBibfEjNDiC+d3l5eaUc=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit src version;
    pname = "next-ls-deps";
    hash = "sha256-4Rt5Q0fX+fbncvxyXdpIhgEvn9VYX/QDxDdnbanT21Q=";
  };

  removeCookie = false;

  # replace installPhase to change release target
  installPhase = ''
    runHook preInstall

    mix release --no-deps-check --path $out plain
    makeWrapper $out/bin/plain $out/bin/nextls --add-flags "eval \"System.no_halt(true); Application.ensure_all_started(:next_ls)\""

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.elixir-tools.dev/next-ls/";
    changelog = "https://github.com/elixir-tools/next-ls/releases/tag/v${version}";
    description = "Language server for Elixir that just works";
    license = lib.licenses.mit;
    mainProgram = "nextls";
    maintainers = [ lib.maintainers.adamcstephens ];
    platforms = beamPackages.erlang.meta.platforms;
  };
}
