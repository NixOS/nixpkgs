{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anda";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "FyraLabs";
    repo = "anda";
    tag = finalAttrs.version;
    hash = "sha256-/1N3ivvnlSBK9qYOAiH96tE/k+S3+EBfsycN2QV8o70=";
  };

  cargoHash = "sha256-keS3z1Kyx6TKObAneQ/+qCp/1ueYQOdepdnAPiJs9qI=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A modern Build/CI System";
    homepage = "https://github.com/FyraLabs/anda";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "anda";
  };
})
