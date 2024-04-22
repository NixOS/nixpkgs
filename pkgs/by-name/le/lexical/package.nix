{
  lib,
  beamPackages,
  fetchFromGitHub,
  writeScript,
  elixir,
}:

beamPackages.mixRelease rec {
  pname = "lexical";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "lexical-lsp";
    repo = "lexical";
    rev = "refs/tags/v${version}";
    hash = "sha256-HWqwJ7PAz80bm6YeDG84hLWPE11n06K98GOyeDQWZWU=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit pname version src;

    hash = "sha256-G0mT+rvXZWLJIMfrhxq3TXt26wDImayu44wGEYJ+3CE=";
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
