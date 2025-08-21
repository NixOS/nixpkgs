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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "lexical-lsp";
    repo = "lexical";
    tag = "v${version}";
    hash = "sha256-p8XSJBX1igwC+ssEJGD8wb/ZYaEgLGozlY8N6spo3cA=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit pname version src;

    hash = "sha256-g6BZGJ33oBDXmjbb/kBfPhart4En/iDlt4yQJYeuBzw=";
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
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Next-generation elixir language server";
    homepage = "https://github.com/lexical-lsp/lexical";
    changelog = "https://github.com/lexical-lsp/lexical/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "lexical";
    platforms = beamPackages.erlang.meta.platforms;
  };
}
