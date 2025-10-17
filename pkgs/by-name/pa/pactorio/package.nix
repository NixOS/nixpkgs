{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  bzip2,
}:

rustPlatform.buildRustPackage rec {
  pname = "pactorio";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = "pactorio";
    rev = "v${version}";
    sha256 = "sha256-3+irejeDltf7x+gyJxWBgvPgpQx5uU3DewU23Z4Nr/A=";
  };

  cargoHash = "sha256-1rqYp9OZ7hkZhrU813uBQAOZNdQ3j+OQdM6ia+t5cOc=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ bzip2 ];

  postInstall = ''
    installManPage artifacts/pactorio.1
    installShellCompletion artifacts/pactorio.{bash,fish} --zsh artifacts/_pactorio
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = {
    description = "Mod packager for factorio";
    mainProgram = "pactorio";
    homepage = "https://github.com/figsoda/pactorio";
    changelog = "https://github.com/figsoda/pactorio/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
