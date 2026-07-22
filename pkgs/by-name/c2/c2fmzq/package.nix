{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "c2FmZQ";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "photos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qIJnrMqsaa7GcsJpyWHhi6nea72XCQy5BaGWBtQKzFo=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  sourceRoot = "${finalAttrs.src.name}/c2FmZQ";

  vendorHash = "sha256-hJHnbG/NlhibY8e59hk0u5vi50x4s4mH/awPdCRkDFk=";

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
