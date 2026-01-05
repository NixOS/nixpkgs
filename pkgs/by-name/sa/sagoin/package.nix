{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "sagoin";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = "sagoin";
    rev = "v${version}";
    hash = "sha256-zXYjR9ZFNX2guUSeMN/G77oBIlW3AowFWA4gwID2jQs=";
  };

  cargoHash = "sha256-JM7m/VdaXpUlPOi+N7gue6mlQuxvRFU6++SaSq45Ntg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage artifacts/sagoin.1
    installShellCompletion artifacts/sagoin.{bash,fish} --zsh artifacts/_sagoin
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = {
    description = "Command-line submission tool for the UMD CS Submit Server";
    homepage = "https://github.com/figsoda/sagoin";
    changelog = "https://github.com/figsoda/sagoin/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    mainProgram = "sagoin";
  };
}
