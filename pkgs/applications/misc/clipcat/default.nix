{ lib
, fetchFromGitHub
, installShellFiles
, rustPlatform
, rustfmt
, xorg
, pkg-config
, protobuf
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dV17xP6xG6Nyi6m0CdH8Mk4Y0giDtsv/QiM23jF58q0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "x11-clipboard-0.6.0" = "sha256-dKx2kda5JC79juksP2qiO9yfeFCWymcYhGPSygQ0mrg=";
    };
  };

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [
    pkg-config

    rustPlatform.bindgenHook

    rustfmt
    protobuf

    python3

    installShellFiles
  ];

  buildInputs = [ xorg.libxcb ];

  buildFeatures = [ "all" ];

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
    mainProgram = "clipcatd";
  };
}
