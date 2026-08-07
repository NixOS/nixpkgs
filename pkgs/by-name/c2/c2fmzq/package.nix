{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "c2FmZQ";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "photos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7Jguv2T6x3zKRWcp7XGzmVakwXcsVz2BWcY6uADGPsg=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  sourceRoot = "${finalAttrs.src.name}/c2FmZQ";

  vendorHash = "sha256-6rKFgCKhJQSquMhv7iuzMsm+84qz3V0ynIyB4rv2Kk8=";

  subPackages = [
    "c2FmZQ-client"
    "c2FmZQ-server"
  ];

  passthru.tests = { inherit (nixosTests) c2fmzq; };

  meta = {
    description = "Securely encrypt, store, and share files, including but not limited to pictures and videos";
    homepage = "https://github.com/c2FmZQ/photos";
    license = lib.licenses.gpl3Only;
    mainProgram = "c2FmZQ-server";
    maintainers = with lib.maintainers; [ hmenke ];
    platforms = lib.platforms.linux;
  };
})
