{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prism-cli";
  version = "5.15.6";

  src = fetchFromGitHub {
    owner = "stoplightio";
    repo = "prism";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TVY1hub6bC/4kl+DxUL7FPOQP44mQqcAUWfZP7dt3f8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-/i0Z4IGZW/AfnaG49J0SnQPntVuEk0LvEC2S+VFN/mg=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/prism" "$out/bin"
    # -L resolves workspace symlinks (e.g. @stoplight/prism-cli -> ../../packages/cli)
    # into real directories so the store path is self-contained.
    cp -rL node_modules "$out/lib/prism/node_modules"
    makeWrapper "${nodejs}/bin/node" "$out/bin/prism" \
      --add-flags "$out/lib/prism/node_modules/@stoplight/prism-cli/dist/index.js"
    runHook postInstall
  '';

  meta = {
    description = "Turn any OpenAPI2/3 and Postman Collection file into an API server with mocking, transformations and validations";
    homepage = "https://github.com/stoplightio/prism";
    changelog = "https://github.com/stoplightio/prism/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "prism";
    platforms = lib.platforms.unix;
  };
})
