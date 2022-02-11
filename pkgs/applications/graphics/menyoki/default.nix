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
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2k8CRya9SylauYV+2aQS2QHkQhyiTHMgGp1DNoZ4jbU=";
  };

  cargoSha256 = "sha256-NLPqJepg0WRt/X3am9J7vwIE9bn+dt2UHE26Dc/QRMM=";

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
