{
  lib,
  fetchFromGitHub,
  installShellFiles,
  libcap,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "authoscope";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "authoscope";
    tag = "v${version}";
    hash = "sha256-SKgb/N249s0+Rb59moBT/MeFb4zAAElCMQJto0diyUk=";
  };

  cargoHash = "sha256-TagEeT6EgvFgdEc/M7dVn9vC1TmAA2zou5ZoWX46fOI=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libcap
    zlib
    openssl
  ];

  postInstall = ''
    installManPage docs/${pname}.1
  '';

  # Tests requires access to httpin.org
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scriptable network authentication cracker";
    homepage = "https://github.com/kpcyrd/authoscope";
    changelog = "https://github.com/kpcyrd/authoscope/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
