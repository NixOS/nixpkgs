{ lib, fetchFromGitHub, installShellFiles, rustPlatform, rustfmt, xorg
, pkgconfig, llvmPackages, clang, protobuf, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.4.19";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lhnm521qqy3aw2iyk1dv4yc5ms0c5x5iipx96bz6v6y0cnmf4kw";
  };

  cargoSha256 = "04iflyvz8g53z658rkxafiyi2m9kzxwl3p1xgkjq7vacmz5jk15c";

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [
    pkgconfig

    clang
    llvmPackages.libclang

    rustfmt
    protobuf

    python3

    installShellFiles
  ];
  buildInputs = [ xorg.libxcb ];

  cargoBuildFlags = [ "--features=all" ];

  postInstall = ''
    installShellCompletion --bash --name clipcatd             completions/bash-completion/completions/clipcatd
    installShellCompletion --fish --name clipcatd.fish        completions/fish/completions/clipcatd.fish
    installShellCompletion --zsh  --name _clipcatd            completions/zsh/site-functions/_clipcatd

    installShellCompletion --bash --name clipcatctl           completions/bash-completion/completions/clipcatctl
    installShellCompletion --fish --name clipcatctl.fish      completions/fish/completions/clipcatctl.fish
    installShellCompletion --zsh  --name _clipcatctl          completions/zsh/site-functions/_clipcatctl

    installShellCompletion --bash --name clipcat-menu         completions/bash-completion/completions/clipcat-menu
    installShellCompletion --fish --name clipcat-menu.fish    completions/fish/completions/clipcat-menu.fish
    installShellCompletion --zsh  --name _clipcat-menu        completions/zsh/site-functions/_clipcat-menu

    installShellCompletion --bash --name clipcat-notify       completions/bash-completion/completions/clipcat-notify
    installShellCompletion --fish --name clipcat-notify.fish  completions/fish/completions/clipcat-notify.fish
    installShellCompletion --zsh  --name _clipcat-notify      completions/zsh/site-functions/_clipcat-notify
  '';

  meta = with lib; {
    description = "Clipboard Manager written in Rust Programming Language";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}
