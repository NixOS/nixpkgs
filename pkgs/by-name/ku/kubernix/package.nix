{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubernix";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = "kubernix";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-/abdmhDCakSbVj1SK9EqVw2MDdCc760IFIUIg3HGAJU=";
  };

  cargoHash = "sha256-0buTnenDDLTW8Cy72Hsg4raTj0t3TaHskh1ed1QzmLc=";

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
