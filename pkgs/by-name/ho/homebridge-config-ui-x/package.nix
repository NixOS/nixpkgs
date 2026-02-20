{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  python3,
  cacert,
  versionCheckHook,
  nodejs_22,
}:

buildNpmPackage.override { nodejs = nodejs_22; } (finalAttrs: {
  pname = "homebridge-config-ui-x";
  version = "5.16.0";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge-config-ui-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LXOfpOmYEeHDL0uMvRSG4q51k00tyKBEU6XP6UFm/RY=";
  };

  # Deps hash for the root package
  npmDepsHash = "sha256-MUfDMHxnwEBjv76NoJ6CYP3YJ+us0Nn/MUFcR1NFQAE=";

  # Deps src and hash for ui subdirectory
  npmDeps_ui = fetchNpmDeps {
    name = "npm-deps-ui";
    src = "${finalAttrs.src}/ui";
    hash = "sha256-GB17rJ2D1yXl/lxM8pQl2e2xnakgA8JLX7sbbdk3P5M=";
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
  # Remove this (and the makeCacheWritable in preBuild), once we fix
  # compiling node-pty on darwin
  makeCacheWritable = stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cacert ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Configure Homebridge, monitor and backup from a browser";
    homepage = "https://github.com/homebridge/homebridge-config-ui-x";
    license = lib.licenses.mit;
    mainProgram = "hb-service";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
    # Works on darwin when not in sandbox because it downloads a prebuilt binary
    # for node-pty at build time, which does not work in sandbox.
    # Need to figure out why this error occurs:
    # ../src/unix/pty.cc:478:13: error: use of undeclared identifier 'openpty'
    # int ret = openpty(&master, &slave, nullptr, NULL, static_cast<winsize*>(&winp));
    broken = stdenv.hostPlatform.isDarwin;
  };
})
