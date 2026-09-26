{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "coldsnap";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "coldsnap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AQwLZM/33jcJXjsAGC+kZ6XLijgcluLwcVokw+nj+J8=";
  };

  cargoHash = "sha256-7c++lklOLI1tg1I4GUJXHl64qsUabXxD0gVkDEKj3uA=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "Command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "coldsnap";
  };
})
