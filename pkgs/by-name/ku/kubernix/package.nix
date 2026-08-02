{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubernix";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = "kubernix";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-8wFrcs1XuW8Fz4P12eHAeA62ZthwO9grrtTHxhL+f1o=";
  };

  cargoHash = "sha256-sz7omys2cLTx+pHmQKjikxwJjSz8P0scO59KI2zm2e0=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    mainProgram = "kubernix";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ saschagrunert ];
    platforms = lib.platforms.linux;
  };
})
