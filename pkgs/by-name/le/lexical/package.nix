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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "lexical-lsp";
    repo = "lexical";
    rev = "refs/tags/v${version}";
    hash = "sha256-YKp1IOBIt6StYpVZyTj3BMZM/+6Bp+galbFpuBKYeOM=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit pname version src;

    hash = "sha256-myxmQM46TELDu9wpr82qxqH4s/YR9t0gdAfGOm0Dw1k=";
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
