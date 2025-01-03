{
  stdenv,
  lib,
  nixosTests,
  fetchFromGitHub,
  nodejs,
  pnpm,
  python3,
  node-gyp,
  cacert,
  xcbuild,
  libkrb5,
  libmongocrypt,
  postgresql,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n8n";
  version = "1.57.0";

  src = fetchFromGitHub {
    owner = "n8n-io";
    repo = "n8n";
    rev = "n8n@${finalAttrs.version}";
    hash = "sha256-0ShG/9Hj132mbNC06HzduMCosAefufbI1M/KJUYK1TQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-EfK8cmfkVebc/kIYaW+Eje1oPW1EpVpa2/jMs+KE5wg=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    python3 # required to build sqlite3 bindings
    node-gyp # required to build sqlite3 bindings
    cacert # required for rustls-native-certs (dependency of turbo build tool)
    makeWrapper
  ] ++ lib.optional stdenv.isDarwin [ xcbuild ];

  buildInputs = [
    nodejs
    libkrb5
    libmongocrypt
    postgresql
  ];

  buildPhase = ''
    runHook preBuild

    pushd node_modules/sqlite3
    node-gyp rebuild
    popd

    # TODO: use deploy after resolved https://github.com/pnpm/pnpm/issues/5315
    pnpm build --filter=n8n

    runHook postBuild
  '';

  preInstall = ''
    echo "Removing non-deterministic files"

    rm -r $(find -type d -name .turbo)
    rm node_modules/.modules.yaml
    rm packages/nodes-base/dist/types/nodes.json

    echo "Removed non-deterministic files"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/n8n}
    mv {packages,node_modules} $out/lib/n8n

    makeWrapper $out/lib/n8n/packages/cli/bin/n8n $out/bin/n8n \
      --set N8N_RELEASE_TYPE "stable"

    runHook postInstall
  '';

  passthru = {
    tests = nixosTests.n8n;
    updateScript = nix-update-script { };
  };

  dontStrip = true;

  meta = with lib; {
    description = "Free and source-available fair-code licensed workflow automation tool";
    longDescription = ''
      Free and source-available fair-code licensed workflow automation tool.
      Easily automate tasks across different services.
    '';
    homepage = "https://n8n.io";
    changelog = "https://github.com/n8n-io/n8n/releases/tag/${finalAttrs.src.rev}";
    maintainers = with maintainers; [
      freezeboy
      gepbird
      k900
    ];
    license = licenses.sustainableUse;
    mainProgram = "n8n";
    platforms = platforms.unix;
  };
})
