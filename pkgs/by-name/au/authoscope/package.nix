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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "authoscope";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "authoscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fLK5AmRuFpj/5pKA451aV0R0TC4zUQqrNPOiFS/CCTk=";
  };

  cargoHash = "sha256-uS1ALPYsv+YEY0z24GDwQe0foQMBl8e29ExarTnRQps=";

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
    installManPage docs/authoscope.1
  '';

  # Tests requires access to httpin.org
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scriptable network authentication cracker";
    homepage = "https://github.com/kpcyrd/authoscope";
    changelog = "https://github.com/kpcyrd/authoscope/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
