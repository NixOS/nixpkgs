{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  makeWrapper,
  pkg-config,
  ronn,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.13.2";

  src = fetchCrate {
    inherit version;
    pname = "https";
    hash = "sha256-uxEMgSrcxMZD/3GQuH9S/oYtMUPzgMR61ZzLcb65zXU=";
  };

  cargoHash = "sha256-DXSHaiiIRdyrlX4UYPFD3aTAv65k3x/PU2VW047odH0=";

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
    changelog = "https://github.com/thecoshman/http/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
