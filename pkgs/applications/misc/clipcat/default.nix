{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9BilasXc/3FFPcKAgPvc0hIHP7NbOqRD8ZwIMRc/Y3M=";
  };

  cargoHash = "sha256-zkeKhi0DiYqA5+KiU77ZJXRyhLUKVDmHvF7TG1URzo4=";

  nativeBuildInputs = [
    protobuf
    installShellFiles
  ];

  checkFlags = [
    # Some test cases interact with X11, skip them
    "--skip=test_x11_clipboard"
    "--skip=test_x11_primary"
  ];

  postInstall = ''
    for cmd in clipcatd clipcatctl clipcat-menu clipcat-notify; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completions bash) \
        --fish <($out/bin/$cmd completions fish) \
        --zsh  <($out/bin/$cmd completions zsh)
    done
  '';

  meta = with lib; {
    description = "Clipboard Manager written in Rust Programming Language";
    homepage = "https://github.com/xrelkd/clipcat";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "clipcatd";
  };
}
