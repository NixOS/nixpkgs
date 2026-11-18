{
  lib,
  stdenvNoCC,
  libsass,
  vips,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lemmy-ui";
  version = "0.19.21";

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = "lemmy-ui";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-2M5noLwLo6x44dfrwLkz+X3BUpSiWoXmoahGGT94yak=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_11
  ];

  buildInputs = [
    libsass
    vips
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-hCyA8hKamPKfxJ8nq7wj+teoihhsijBnLGY6KI5DCbg=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run prebuild:prod
    # Required to pass a custom value for COMMIT_HASH, as the normal
    # `pnpm build:prod` tries to derive its value by running `git`.
    # This value is only injected into the templated asset URLs for cache invalidation,
    # so we don't really need a commit hash here, just a value that changes on every
    # update.
    pnpm exec webpack --env COMMIT_HASH="${finalAttrs.version}" --mode=production

    runHook postBuild
  '';

  preInstall = ''
    mkdir $out
    cp -R ./dist $out
    cp -R ./node_modules $out
  '';

  preFixup = ''
    find $out -name libvips-cpp.so.42 -print0 | while read -d $'\0' libvips; do
      echo replacing libvips at $libvips
      rm $libvips
      ln -s ${lib.getLib vips}/lib/libvips-cpp.so.42 $libvips
    done
  '';

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script { };
    tests.lemmy-ui = nixosTests.lemmy;
  };

  meta = {
    description = "Web frontend for a federated link aggregator";
    homepage = "https://join-lemmy.org/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      happysalada
      billewanick
      georgyo
      lucasew
    ];
    teams = [ lib.teams.ngi ];
    inherit (nodejs.meta) platforms;
  };
})
