{
  lib,
  stdenv,
  darwin,
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

  cargoHash = "sha256-rSHuKy86iJNLAKSVcb7fn7A/cc75EOc97jGI14EaC6k=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [
      libcap
      zlib
      openssl
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
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
