{
  stdenv,
  nodejs,
  fetchFromGitHub,
  makeWrapper,
  lib,
  pnpm_9,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphql-inspector";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "kamilkisiela";
    repo = "graphql-inspector";
    rev = "release-1731490071726";
    hash = "sha256-/wM00N5fJGbCXAP+RCJokAYoc33JXIl5dBX00jIV7/k=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    makeWrapper
  ];

  buildInputs = [ nodejs ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-NAuzQsFoiAtG5J+7lJq3ESbiEWOjsbZw7/7UhoL5tBc=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  preInstall = ''
    rm node_modules/.modules.yaml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/graphql-inspector}
    mv {packages,node_modules} $out/lib/graphql-inspector

    makeWrapper $out/lib/graphql-inspector/packages/cli/dist/cjs/index.js $out/bin/graphql-inspector

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  dontStrip = true;

  meta = {
    description = "Tooling for GraphQL. Compare GraphQL Schemas, check documents, find breaking changes, find similar types.";
    homepage = "https://github.com/kamilkisiela/graphql-inspector";
    changelog = "https://github.com/kamilkisiela/graphql-inspector/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "graphql-inspector";
    maintainers = with lib.maintainers; [ thenonameguy ];
  };
})
