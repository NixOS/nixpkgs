{ fetchFromGitHub
, installShellFiles
, lib
, pkg-config
, rustPlatform
, stdenv
, libX11
, libXrandr
, AppKit
, withSki ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "menyoki";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7dqV18+Q0M1PrSXfMro5bUqSeA72Stj5JfP4MsTlrjM=";
  };

  cargoSha256 = "sha256-c3VpHr/X2tKh7mY4dOQac0lS7oem0GGqjzv7feNwc24=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optionals stdenv.isLinux [ libX11 libXrandr ]
    ++ lib.optional stdenv.isDarwin AppKit;

  buildNoDefaultFeatures = !withSki;

  postInstall = ''
    installManPage man/*
    installShellCompletion completions/menyoki.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Screen{shot,cast} and perform ImageOps on the command line";
    homepage = "https://menyoki.cli.rs/";
    changelog = "https://github.com/orhun/menyoki/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
