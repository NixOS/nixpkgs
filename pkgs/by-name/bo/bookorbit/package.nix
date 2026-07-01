{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  ffmpeg,
  makeWrapper,
  nixosTests,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bookorbit";
  version = "1.10.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bookorbit";
    repo = "bookorbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bNO1U8f8mkPojWJef8HtvGu+j5fu+t7XveqXkUSKQok=";
  };

  pnpmWorkspaces = [
    "client..."
    "server..."
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-SYrme7cFO1ORgsnnG3kXcSQ4Jd7YlOF20eqy44r1fj4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    ffmpeg
    makeWrapper
  ];

  # This workaround turns the `pnpmWorkspaces` array into a space-separated
  # string. This format is supported by both `pnpmConfigHook` and `pnpmBuildHook`.
  # TODO: remove this when`pnpmConfigHook` supports `___structuredAttrs = true;`
  # https://github.com/NixOS/nixpkgs/issues/528547
  preConfigure = ''
    __pnpmWorkspaces="''${pnpmWorkspaces[@]}"
    unset pnpmWorkspaces
    declare -g pnpmWorkspaces="$__pnpmWorkspaces"
  '';

  postPatch = ''
    # Restrict optional platform-specific dependencies to the target platform.
    # Without this, pnpm resolves @parcel/watcher-darwin-x64, @parcel/watcher-win32-x64, etc.
    # during its headless install, causing network errors in the sandboxed build.
    echo "supported-architectures.os[]=${stdenv.hostPlatform.node.platform}" >> .npmrc
    echo "supported-architectures.cpu[]=${stdenv.hostPlatform.node.arch}" >> .npmrc
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "supported-architectures.libc[]=${
      if stdenv.hostPlatform.isMusl then "musl" else "glibc"
    }" >> .npmrc
  '';

  buildPhase = ''
    runHook preBuild

    pnpm config set inject-workspace-packages true

    pnpm --filter client run build-only
    pnpm --filter server run build

    mkdir ./deploy
    pnpm --filter server deploy --prod ./deploy

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r deploy/* $out/lib/
    cp -r client/dist $out/lib/public
    cp -r server/src/db/migrations $out/lib/migrations

    makeWrapper ${nodejs}/bin/node $out/bin/bookorbit \
      --run "cd $out/lib" \
      --set NODE_ENV production \
      --add-flags "$out/lib/dist/main.js"

    makeWrapper ${nodejs}/bin/node $out/bin/bookorbit-migrate \
      --set NODE_ENV production \
      --add-flags "$out/lib/dist/scripts/migrate.js"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) bookorbit;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "BookOrbit, self-hosted library management and reading platform for ebooks, PDFs, audiobooks, and comics.";
    homepage = "https://github.com/bookorbit/bookorbit";
    changelog = "https://github.com/bookorbit/bookorbit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ iv-nn ];
    mainProgram = "bookorbit";
    platforms = lib.platforms.all;
  };
})
