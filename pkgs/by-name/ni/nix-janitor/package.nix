{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-janitor";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nobbz";
    repo = "nix-janitor";
    rev = "refs/tags/${version}";
    hash = "sha256-xoVByI17rt2SCY3ULg12S8QsoXGhQWZlOpPpK2mfcPY=";
  };

  cargoHash = "sha256-QG2hHM4KBSU6+droew2WnOFxWRTpk9griIPMD8MLSbw=";

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
    description = "A tool to clean up old profile generations";
    mainProgram = "janitor";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nobbz ];
  };
}
