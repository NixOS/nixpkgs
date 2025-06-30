{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-connect-openapi";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "sudorandom";
    repo = "protoc-gen-connect-openapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zQAPMnrdKl2gku58U0sKyfObmwh6I2SJUCreO8Hya2M=";
  };

  vendorHash = "sha256-YZZs+xj+ZnRC3nASfkLX3n0sPxEdYf0mHlQ0JbVfzTw=";

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
