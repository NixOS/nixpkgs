{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nkeys";
    tag = "v${version}";
    hash = "sha256-dSkIT+KW+hT/Rk3NSkrb5ABLLiGGz2dppr9rwhjLOnM=";
  };

  vendorHash = "sha256-89DGLTkt9c8jJhAX3Uo8BBtLcBbnYE0q4mCqq/RGXM4=";

  meta = {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nk";
  };
}
