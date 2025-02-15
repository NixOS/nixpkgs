{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "sagoin";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zXYjR9ZFNX2guUSeMN/G77oBIlW3AowFWA4gwID2jQs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JM7m/VdaXpUlPOi+N7gue6mlQuxvRFU6++SaSq45Ntg=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  postInstall = ''
    installManPage artifacts/sagoin.1
    installShellCompletion artifacts/sagoin.{bash,fish} --zsh artifacts/_sagoin
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = with lib; {
    description = "Command-line submission tool for the UMD CS Submit Server";
    homepage = "https://github.com/figsoda/sagoin";
    changelog = "https://github.com/figsoda/sagoin/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "sagoin";
  };
}
