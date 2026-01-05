{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  hwatch,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.19";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = "hwatch";
    tag = version;
    sha256 = "sha256-lMsBzMDMgpHxcQFtfZ4K7r2WRUaVR8Ry/kPvwfzPObI=";
  };

  cargoHash = "sha256-UnaZZEmX5XoTVFLEFj5JkJXJkjoUBwzJokfffJTPP4M=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd hwatch \
      --bash $src/completion/bash/hwatch-completion.bash \
      --fish $src/completion/fish/hwatch.fish \
      --zsh $src/completion/zsh/_hwatch \
  '';

  passthru.tests.version = testers.testVersion {
    package = hwatch;
  };

  meta = with lib; {
    homepage = "https://github.com/blacknon/hwatch";
    description = "Modern alternative to the watch command";
    longDescription = ''
      A modern alternative to the watch command, records the differences in
      execution results and can check this differences at after.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ hamburger1984 ];
    mainProgram = "hwatch";
  };
}
