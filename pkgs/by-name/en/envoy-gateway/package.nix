{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "envoy-gateway";
  version = "1.9.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ujYgHKsXyUvq7fbq44QMvJwRopJpMQy3A2zEgTeQYNY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-bKwwecHenIx1GQi8IthZKM3QxRetPXdlzDzv+d3jDl0=";

  subPackages = [ "cmd/envoy-gateway" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/envoyproxy/gateway/internal/cmd/version.envoyGatewayVersion=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Kubernetes controller that manages Envoy Proxy as an application gateway";
    homepage = "https://gateway.envoyproxy.io";
    changelog = "https://github.com/envoyproxy/gateway/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "envoy-gateway";
  };
})
