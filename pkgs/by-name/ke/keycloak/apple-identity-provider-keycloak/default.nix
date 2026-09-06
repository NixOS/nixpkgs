{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  nix-update-script,
}:
let
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apple-identity-provider-keycloak";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "klausbetz";
    repo = "apple-identity-provider-keycloak";
    tag = finalAttrs.version;
    hash = "sha256-0/uHQwgyHwy+5ynRHs0ot0iIBVUckEs65YxkWLQNgbY=";
  };

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" build/libs/apple-identity-provider-${finalAttrs.version}.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/klausbetz/apple-identity-provider-keycloak";
    changelog = "https://github.com/klausbetz/apple-identity-provider-keycloak/releases/tag/${finalAttrs.version}";
    description = "Keycloak identity provider extension for Sign in with Apple";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anish ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    platforms = lib.platforms.unix;
  };
})
