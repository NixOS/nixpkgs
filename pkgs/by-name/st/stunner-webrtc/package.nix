{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "stunner";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "firefart";
    repo = "stunner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A/k43ZOk/JIpCHBI1ygFBjmbDWWmLMIzuDbM6+8FKdw=";
  };

  vendorHash = "sha256-cXvHNn4BbVVUVgy5IwCe/K1ISV8CyDilJrNYEK2QFU8=";

  meta = {
    description = "Test and exploit STUN, TURN and TURN over TCP servers";
    homepage = "https://github.com/firefart/stunner";
    changelog = "https://github.com/firefart/stunner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ hougo ];
    mainProgram = "stunner";
  };
})
