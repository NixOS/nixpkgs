{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  python3,
  cacert,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge-config-ui-x";
  version = "4.75.0";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge-config-ui-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmr35ejcON5haUKkXiLBqAVSkP26QYVc3Ftnc76KnYw=";
  };

  # Deps hash for the root package
  npmDepsHash = "sha256-aqG9GQ2gdrCz+lxTOVYFo96jusb710KkguN/5R0Ye6c=";

  # Deps src and hash for ui subdirectory
  npmDeps_ui = fetchNpmDeps {
    name = "npm-deps-ui";
    src = "${finalAttrs.src}/ui";
    hash = "sha256-WHGg2sINF1fH3tnuZsf+yjqoyWSPU5osOhuZb5VU+8I=";
  };

  # Need to also run npm ci in the ui subdirectory
  preBuild = ''
    # Tricky way to run npmConfigHook multiple times
    (
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=ui npmDeps=${finalAttrs.npmDeps_ui} makeCacheWritable= npmConfigHook
    )
    # Required to prevent "ng build" from failing due to
    # prompting user for autocompletion
    export CI=true
  '';

  # On darwin, the build failed because openpty() is not declared
  # Uses the prebuild version of @homebridge/node-pty-prebuilt-multiarch instead
  makeCacheWritable = stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ cacert ];

  meta = {
    description = "Homebridge Config UI X";
    homepage = "https://github.com/homebridge/homebridge-config-ui-x";
    license = lib.licenses.mit;
    mainProgram = "homebridge-config-ui-x";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})
