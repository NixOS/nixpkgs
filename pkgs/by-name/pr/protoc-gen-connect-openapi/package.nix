{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-connect-openapi";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "sudorandom";
    repo = "protoc-gen-connect-openapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+8+DpObBxJZihy0kHOReDIlfZGRMQy6yUkGh864pJk=";
  };

  vendorHash = "sha256-ubcJP5q70F4mTqx+f8V+lCfjiGHxOvdPVaUwhVLmhb8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protobuf plugin for generating OpenAPI specs matching the Connect RPC interface";
    mainProgram = "protoc-gen-connect-openapi";
    homepage = "https://github.com/sudorandom/protoc-gen-connect-openapi";
    changelog = "https://github.com/sudorandom/protoc-gen-connect-openapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      spotdemo4
    ];
    platforms = lib.platforms.all;
  };
})
