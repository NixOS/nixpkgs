{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  hwatch,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hwatch";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = "hwatch";
    tag = finalAttrs.version;
    sha256 = "sha256-ic83D46CGDWRqcNJt/KcMEsnKj6rO/LsTNm247YK/Qs=";
  };

  cargoHash = "sha256-xJZpZPhjU81cb00O/FE0QGOsRKY9BG4oGMk2jNy2skw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd hwatch \
      --bash $src/completion/bash/hwatch-completion.bash \
      --fish $src/completion/fish/hwatch.fish \
      --zsh $src/completion/zsh/_hwatch
  '';

  passthru.tests.version = testers.testVersion {
    package = hwatch;
  };

  meta = {
    homepage = "https://github.com/blacknon/hwatch";
    description = "Modern alternative to the watch command";
    longDescription = ''
      A modern alternative to the watch command, records the differences in
      execution results and can check this differences at after.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hamburger1984 ];
    mainProgram = "hwatch";
  };
})
