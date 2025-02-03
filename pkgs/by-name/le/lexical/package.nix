{
  lib,
  beamPackages,
  fetchFromGitHub,
  elixir,
  nix-update-script,
  testers,
  lexical,
}:

beamPackages.mixRelease rec {
  pname = "lexical";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lexical-lsp";
    repo = "lexical";
    rev = "refs/tags/v${version}";
    hash = "sha256-veIFr8oovEhukwkGzj02pdc6vN1FCXGz1kn4FAcMALQ=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit pname version src;

    hash = "sha256-pqghYSBeDHfeZclC7jQU0FbadioTZ6uT3+InEUSW3rY=";
  };

  installPhase = ''
    runHook preInstall

    mix do compile --no-deps-check, package --path "$out"

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace "$out/bin/start_lexical.sh" --replace 'elixir_command=' 'elixir_command="${elixir}/bin/"'
    mv "$out/bin" "$out/libexec"
    makeWrapper "$out/libexec/start_lexical.sh" "$out/bin/lexical" --set RELEASE_COOKIE lexical
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = lexical; };
  };

  meta = {
    description = "Lexical is a next-generation elixir language server";
    homepage = "https://github.com/lexical-lsp/lexical";
    changelog = "https://github.com/lexical-lsp/lexical/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "lexical";
    platforms = beamPackages.erlang.meta.platforms;
  };
}
