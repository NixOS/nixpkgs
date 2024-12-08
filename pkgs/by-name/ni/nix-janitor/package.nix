{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-janitor";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "nobbz";
    repo = "nix-janitor";
    rev = "refs/tags/${version}";
    hash = "sha256-MRhTkxPl0tlObbXO7/0cD2pbd9/uQCeRKV3DStGvZMQ=";
  };

  cargoHash = "sha256-XFO4ec++lT04JpwqGtD3kWX4vmgmeBPSULxZENddYm0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      completionFile=janitor.$shell
      $out/bin/janitor --completions $shell > $completionFile
      installShellCompletion $completionFile
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/nobbz/nix-janitor";
    changelog = "https://github.com/NobbZ/nix-janitor/blob/${version}/CHANGELOG.md";
    description = "Tool to clean up old profile generations";
    mainProgram = "janitor";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nobbz ];
  };
}
