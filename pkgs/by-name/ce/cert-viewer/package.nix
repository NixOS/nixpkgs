{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  lib,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "cert-viewer";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "mgit-at";
    repo = "cert-viewer";
    rev = "refs/tags/v${version}";
    hash = "sha256-6IPr2BG3y/7cmc2WkeeFDpQ59GNU1eOhhm49HE2w0cA=";
  };

  vendorHash = "sha256-jNT04bYH5L/Zcfvel673zr2UJLayCO443tvBGZjrBZk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      prog =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/cert-viewer"
        else
          lib.getExe buildPackages.cert-viewer;
    in
    ''
      ${prog} --help-man > cert-viewer.1
      installManPage cert-viewer.1
    '';

  meta = {
    description = "Admin tool to view and inspect multiple x509 Certificates";
    homepage = "https://github.com/mgit-at/cert-viewer";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mkg20001 ];
    mainProgram = "cert-viewer";
  };
}
