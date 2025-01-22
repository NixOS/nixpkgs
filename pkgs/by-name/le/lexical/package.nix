{
  lib,
  beamPackages,
  fetchFromGitHub,
  elixir,
  nix-update-script,
  versionCheckHook,
}:

beamPackages.mixRelease rec {
  pname = "lexical";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "lexical-lsp";
    repo = "lexical";
    tag = "v${version}";
    hash = "sha256-mgchXc46sMN1UcgyO8uWusl2bEJr/5PqfwJ2c6j6SoI=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit pname version src;

    hash = "sha256-Ee8RbLkb7jkdK91G4TAUIlPthBP5OyeynHJGg87UvBI=";
  };

  installPhase = ''
    runHook preInstall

    mix do compile --no-deps-check, package --path "$out"

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace "$out/bin/start_lexical.sh" \
      --replace-fail 'elixir_command=' 'elixir_command="${elixir}/bin/"'

    mv "$out/bin" "$out/libexec"
    makeWrapper "$out/libexec/start_lexical.sh" "$out/bin/lexical" \
      --set RELEASE_COOKIE lexical
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
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
