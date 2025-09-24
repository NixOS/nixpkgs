{
  lib,
  stdenv,
  bundlerEnv,
  buildPackages,
  fetchFromGitHub,
  makeBinaryWrapper,
  nixosTests,
  callPackage,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    # Use bundlerEnvArgs from passthru to allow overriding bundlerEnv arguments.
    rubyEnv = bundlerEnv finalAttrs.passthru.bundlerEnvArgs;
    # We also need a separate nativeRubyEnv to precompile assets on the build
    # host. If possible, reuse existing rubyEnv derivation.
    nativeRubyEnv =
      if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
        rubyEnv
      else
        buildPackages.bundlerEnv finalAttrs.passthru.bundlerEnvArgs;

    bundlerEnvArgs = {
      name = "${finalAttrs.pname}-${finalAttrs.version}-gems";
      gemdir = ./.;
    };
  in
  {
    pname = "pghero";
    version = "3.6.1";

    src = fetchFromGitHub {
      owner = "pghero";
      repo = "pghero";
      rev = "v${finalAttrs.version}";
      hash = "sha256-kABdQRwV5Y/jB9P8kYVmwmntOK0CF/JJYmaINNv26fA=";
    };

    strictDeps = true;
    nativeBuildInputs = [
      nativeRubyEnv
      makeBinaryWrapper
    ];

    inherit rubyEnv;

    buildPhase = ''
      runHook preBuild
      DATABASE_URL=nulldb:/// RAILS_ENV=production rake assets:precompile
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p -- "$out"/{share,bin}
      cp -a -- . "$out"/share/pghero
      makeWrapper "$rubyEnv"/bin/puma "$out"/bin/pghero \
        --add-flags -C \
        --add-flags config/puma.rb \
        --chdir "$out"/share/pghero
      runHook postInstall
    '';

    passthru = {
      inherit bundlerEnvArgs;
      updateScript = callPackage ./update.nix { };
      tests = {
        inherit (nixosTests) pghero;
      };
    };

    meta = {
      homepage = "https://github.com/ankane/pghero";
      description = "Performance dashboard for Postgres";
      mainProgram = "pghero";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.tie ];
    };
  }
)
