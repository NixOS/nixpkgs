{
  lib,
  beamPackages,
  fetchFromGitHub,
  elixir,
}:

beamPackages.mixRelease rec {
  pname = "lexical";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "lexical-lsp";
    repo = "lexical";
    rev = "refs/tags/v${version}";
    hash = "sha256-gDiNjtYeEGoYoyoNmPh73EuYCvY36y9lUyLasbFrFgs=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit pname version src;

    hash = "sha256-xihxPfdLPr5jWFfcX2tccFUl7ND1mi9u8Dn28k6lGVA=";
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

  meta = with lib; {
    description = "Lexical is a next-generation elixir language server";
    homepage = "https://github.com/lexical-lsp/lexical";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "lexical";
    platforms = beamPackages.erlang.meta.platforms;
  };
}
