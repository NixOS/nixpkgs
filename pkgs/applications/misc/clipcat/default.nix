{ lib, fetchFromGitHub, installShellFiles, rustPlatform, rustfmt, xorg
, pkg-config, llvmPackages, clang, protobuf, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rxl3ksjinw07q3p2vjqg80k3c6wx2q7pzpf2344zyfb4gkqzx1c";
  };

  cargoSha256 = "1ffgvhkdj8wkhlgi0cj0njdm9ycxq2qda4b5qn8bmaygzr2zkwpd";

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [
    pkg-config

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
    installShellCompletion --bash completions/bash-completion/completions/*
    installShellCompletion --fish completions/fish/completions/*
    installShellCompletion --zsh  completions/zsh/site-functions/*
  '';

  meta = with lib; {
    description = "Clipboard Manager written in Rust Programming Language";
    homepage = "https://github.com/xrelkd/clipcat";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}
