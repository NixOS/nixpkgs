{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "9.0.4";

  src = fetchFromGitHub {
    owner = "findomain";
    repo = "findomain";
    tag = version;
    hash = "sha256-5jbKDMULig6j3D5KEQQrHWtsc59x0Tj6n/7kwK/8IME=";
  };

  cargoHash = "sha256-4+nRQ8HL4dQMCgeSOrgkaRj0E4HPAC3Nm82AEr1KWJo=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    installManPage findomain.1
  '';

  meta = {
    description = "Fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Findomain/Findomain";
    changelog = "https://github.com/Findomain/Findomain/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      figsoda
    ];
    mainProgram = "findomain";
  };
}
