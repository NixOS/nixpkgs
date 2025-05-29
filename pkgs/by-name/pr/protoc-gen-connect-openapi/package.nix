{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-connect-openapi";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "sudorandom";
    repo = "protoc-gen-connect-openapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ek9yYvTBrZZUtQAHdTW6dNO72jInWlYi7WvZKVjjxQo=";
  };

  vendorHash = "sha256-9v3TESnFQA/KzkVHDPui7eh5tn1AGI/ZOi6Qd35lRew=";

  meta = {
    description = "Plugin for generating OpenAPIv3 from protobufs matching the Connect RPC interface";
    mainProgram = "protoc-gen-connect-openapi";
    homepage = "https://github.com/sudorandom/protoc-gen-connect-openapi";
    changelog = "https://github.com/sudorandom/protoc-gen-connect-openapi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      spotdemo4
    ];
  };
})
