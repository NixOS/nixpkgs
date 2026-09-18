{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubernix";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = "kubernix";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-d+W7V/9TiEqG4q0MIq3Tan5XH/w7vJl5vpCax5Qf7r0=";
  };

  cargoHash = "sha256-83dfQnZ3/6k8fJIr5jyleX2ztevhttnSSfaHLJEWwks=";

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
