{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  pkg-config,
  openssl,
  pandoc,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "dogedns";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "Dj-Codeman";
    repo = "doge";
    rev = "6dd0383f31c096bfe2b6918c36b6e2c48414e753";
    hash = "sha256-cvqDSTHFf/le2jItGTSkAGURj64WRvOmMRI+vFH0/50=";
  };

  cargoHash = "sha256-v9AuX7FZfy18yu4P9ovHsL5AQIYhPa8NEsMziEeHCJ8=";

  patches = [
    # remove date info to make the build reproducible
    # remove commit hash to avoid dependency on git and the need to keep `.git`
    ./remove-date-info.patch
  ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ] ++ lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs =
    lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
    installShellCompletion completions/doge.{bash,fish,zsh}
    installManPage ./target/man/*.1
  '';

  meta = with lib; {
    description = "Reviving A command-line DNS client";
    homepage = "https://github.com/Dj-Codeman/doge";
    license = licenses.eupl12;
    mainProgram = "doge";
    maintainers = with maintainers; [ aktaboot ];
  };
}
