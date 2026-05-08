{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:
python3Packages.buildPythonApplication rec {
  pname = "googler";
  version = "4.3.2";
  pyproject = false;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "jarun";
    repo = "googler";
    rev = "v${version}";
    hash = "sha256-PgWg396AQ15CAnfTXGDpSg1UXx7mNCtknEjJd/KV4MU=";
  };
  nativeBuildInputs = [ installShellFiles ];
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 googler $out/bin/googler
    installManPage googler.1
    installShellCompletion --bash auto-completion/bash/googler-completion.bash
    installShellCompletion --name _googler --zsh auto-completion/zsh/_googler
    installShellCompletion --fish auto-completion/fish/googler.fish
    runHook postInstall
  '';
  meta = {
    description = "Google Search and Google Site Search from the terminal";
    homepage = "https://github.com/jarun/googler";
    license = lib.licenses.gpl3Plus;
    mainProgram = "googler";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
