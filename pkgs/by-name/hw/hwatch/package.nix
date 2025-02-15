{ lib, fetchFromGitHub, rustPlatform, testers, hwatch, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = pname;
    tag = version;
    sha256 = "sha256-E1IxeraZTHY+FDnOhyjygFyqOIwVEvnKuPuuNZvvL7o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gM9KLf2kEY48M8nQrSdBoqdU9ssQj4sH/hma3/+3JTw=";

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
