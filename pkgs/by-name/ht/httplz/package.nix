{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  ronn,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "httplz";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "thecoshman";
    repo = "http";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qinhdpm9eaTdpUk4ZZLaH1D/CZ22k4RisHu8clZCEGo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
    ronn
  ];

  buildInputs = [ openssl ];

  cargoBuildFlags = [
    "--bin"
    "httplz"
  ];

  postInstall = ''
    sed -E 's/http(`| |\(|$)/httplz\1/g' http.md > httplz.1.ronn
    RUBYOPT=-Eutf-8:utf-8 ronn --organization "http developers" -r httplz.1.ronn
    installManPage httplz.1
    wrapProgram $out/bin/httplz \
      --prefix PATH : "${openssl}/bin"
  '';

  meta = {
    description = "Basic http server for hosting a folder fast and simply";
    mainProgram = "httplz";
    homepage = "https://github.com/thecoshman/http";
    changelog = "https://github.com/thecoshman/http/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
  };
})
